\ Forth lexicon for controlling an astronomical camera
\ 	ASI version
\ 	interactive version - errors will report and abort

\ requires ASI_SDK.f
\ requires ASI_SDK_extend.f
\ requires XISF.f

\ Lexicon conventions
\ 	camera.word or cam.ID is a word within the encapsulation
\ 	dash is used as a verb-noun seperator
\ 	underscore is used as a whitespace in a noun (including structure field names and hardware properties)
\ 	camelCase is used as whitespace in a verb (including values and variables)
\ 	word? reports text to the user
\ 	->property ( x --) sets a hardware property
\ 	property ( -- x) returns a hardware property

\ Operational notes
\ 	values over variables
\ 	actions to the presently-selected-camera


: scan-cameras ( -- )
\ scan the plugged-in cameras
\ create a CONSTANT (out of the name and S/N) for each CameraID
\ report the cameras and 
	base @ >R hex									\ report the s/n in hex
	ASIGetNumOfConnectedCameras ( -- n)
	?dup
	IF
		\ loop over each connected camera
		CR ." ID" tab ." Camera" tab tab tab ." S/N" tab tab ." Max_Width" tab ." Max_Height"  tab ." Handle" CR
		0 do
			ASICameraInfo i ( buffer index) ASIGetCameraProperty  ASI.?abort
			ASICameraInfo ASI_CAMERA_ID @				( ID)
			dup .
			ASICameraInfo ASI_CAMERA_NAME zcount tab type			
			dup ASIOpenCamera ASI.?ABORT
			dup ASISN ASIGetSerialNumber ASI.?ABORT 	( ID)
			dup ASICloseCamera ASI.?abort					( ID)
			ASISN @ tab u. 									\ last 8 hex digits only
			ASICameraInfo ASI_MAX_WIDTH @ tab .
			ASICameraInfo ASI_MAX_HEIGHT @ tab tab . 							
			ASI.make-handle									( ID c-addr u)
			2dup tab type CR									( ID c-addr u)
			($constant)											( --)
		loop
	ELSE
	CR ." No connected cameras" CR
	THEN
	R> base !
;

: add-camera ( CameraID --)
\ make a camera available for application use
\ 	connect the camera and initialize it with a full frame
	dup ASIOpenCamera ASI.?abort
	dup ASIInitCamera ASI.?abort
	dup ASICameraInfo ( ID buffer) ASIGetCameraPropertyByID ASI.?abort
	( ID) ASICameraInfo ASI_MAX_WIDTH @ ASICameraInfo ASI_MAX_HEIGHT @ 1 ( width height bin) ASI_IMG_RAW16 ( 16bit unsigned) ASISetROIFormat ASI.?abort
;

: remove-camera ( CameraID --)
\ disconnect the camera, it becomes unavailable to the application
	ASICloseCamera ASI.?abort
;

: use-camera ( CameraID --)
\ choose the camera to be selected for operations
	-> camera.ID
;

: what-camera? ( --)
\ report the current camera to the user
\ CameraID Name SerialNo MaxWidth MaxHeight
	CR ." ID" tab ." Camera" tab tab tab ." S/N" tab tab ." Max_Width" tab ." Max_Height" CR	
	camera.ID .	
	camera.ID ASICameraInfo ( ID buffer) ASIGetCameraPropertyByID ASI.?abort
	camera.ID ASISN ASIGetSerialNumber ASI.?ABORT 
	ASICameraInfo ASI_CAMERA_NAME zcount tab type
	base @ hex									\ report the s/n in hex
	ASISN @ tab u.
	base !
	ASICameraInfo ASI_MAX_WIDTH @ tab .
	ASICameraInfo ASI_MAX_HEIGHT @ tab tab . CR CR
;

ASI_GAIN 					ASI.define-get-control camera_gain
ASI_GAIN 					ASI.define-set-control ->camera_gain
ASI_EXPOSURE				ASI.define-get-control camera_exposure			\ uS
ASI_EXPOSURE				ASI.define-set-control	->camera_exposure		\ uS
ASI_OFFSET					ASI.define-get-control  camera_offset
ASI_OFFSET					ASI.define-set-control	->camera_offset
ASI_COOLER_POWER_PERC	ASI.define-get-control	cooler_power 
ASI_BANDWIDTHOVERLOAD	ASI.define-get-control	camera_bandwidth
ASI_BANDWIDTHOVERLOAD	ASI.define-set-control	->camera_bandwidth
ASI_TEMPERATURE			ASI.define-get-control	|camera_temperature|
ASI_TARGET_TEMP			ASI.define-get-control	target_temperature	\ C
ASI_TARGET_TEMP			ASI.define-set-control	->target_temperature	\ C
ASI_COOLER_ON				ASI.define-get-control	camera_cooler
ASI_COOLER_ON				ASI.define-set-control	->camera_cooler
ASI_ANTI_DEW_HEATER		ASI.define-get-control	camera_dew_heater
ASI_ANTI_DEW_HEATER		ASI.define-set-control	->camera_dew_heater
ASI_FAN_ON					ASI.define-get-control	camera_fan
ASI_FAN_ON					ASI.define-set-control	->camera_fan
ASI_HARDWARE_BIN			ASI.define-get-control	camera_hardware_bin
ASI_HARDWARE_BIN			ASI.define-set-control	->camera_hardware_bin

: camera_temperature
\ return the camera temperature in integer Celcius
	|camera_temperature| ( temp*10) 5 + 10 /
;

: cooler-on
	1 ->camera_cooler
;

: cooler-off
	0 ->camera_cooler
;

: dew_heater-on
	1 ->camera_dew_heater
;

: dew_heater-off
	0 ->camera_dew_heater
;

: fan-on
	1 ->camera_fan
;

: fan-off
	0 ->camera_fan
;

: hardware_bin-on
	1 ->camera_hardware_bin
;

: hardware_bin-off
	0 ->camera_hardware_bin
;

: camera_ROI ( -- width height bin) { | ROIWidth ROIHeight ROIBin ASIImgType }  \ VFX locals for pass-by-reference
	camera.ID ADDR ROIWidth ADDR ROIHeight ADDR ROIBin ADDR ASIImgType ASIGetROIFormat ASI.?ABORT
	ROIWidth ROIHeight ROIBin
;

: ->camera_ROI ( width height bin)
 	camera.ID ( width height bin) ASI_IMG_RAW16 ( 16bit unsigned) 
	ASISetROIFormat ASI.?abort
;

: camera_binning ( -- bin)
\ return the camera binning
	camera_ROI nip nip
;

: ->camera_binning ( bin --)
\ set the camera binning
	camera_ROI drop rot ->camera_ROI
;

: uSecs ( uS -- uS)
\ convert uS to uS
\ for syntax consistency only
;

: mSecs ( mS -- uS)
\ convert uS to mS
	1000 *
;

: Secs ( S -- uS)
\ convert S to uS
	1000000 *
;

: pixel_size ( -- caddr u)
\ return the size of one sensor pixel in um, as a string
	ASICameraInfo ASI_PIXEL_SIZE df@
	3 (f.)
;

: effective_pixel_size ( -- caddr u)
\ return the size of image pixel in um (includes binning), as a string
	ASICameraInfo ASI_PIXEL_SIZE df@
	camera_binning s>f
	f*
	3 (f.)
;

: electrons_per_adu ( -- caddr u)
\ return this paramater as a string
	ASICameraInfo ASI_ELEC_PER_ADU sf@
	6 (f.)
;

: exposure_time ( -- caddr u)
\ return the exposure time in seconds as a string
	camera_exposure s>f
	1.0e6 f/
	fdup 1.0e0 f> if
		0 (f.)
	else
		3 (f.)
	then
;

: start-exposure ( --)
\ initiate an exposure
	camera.ID 0 ( ID isdark) ASIStartExposure ASI.?abort
	CR ." Exposing..." CR 
;

: stop-exposure ( --)
\ stop an exposure
	camera.ID ASIStopExposure ASI.?abort
;

: exposure_status ( -- ASI_EXPOSURE_STATUS) { | exposureStatus }
	camera.ID ADDR exposureStatus ASIGetExpStatus ASI.?abort
	exposureStatus
;

: download-image ( addr u --)
	camera.ID -rot ( ID addr u) ASIGetDataAfterExp ASI.?abort
;