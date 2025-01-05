\ Forth lexicon for controlling an astronomical camera
\ 	ASI version
\ requires forthbase.f
\ requires ASI_SDK.f
\ requires ASI_SDK_extend.f

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

: camera_cooler-on
	1 ->camera_cooler
;

: camera_cooler-off
	0 ->camera_cooler
;

: camera_dew_heater-on
	1 ->camera_dew_heater
;

: camera_dew_heater-off
	0 ->camera_dew_heater
;

: camera_fan-on
	1 ->camera_fan
;

: camera_fan-off
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

: camera_name ( -- caddr u)
\ return the name of the camera
	ASICameraInfo ASI_CAMERA_NAME zcount
;

: camera_SN   ( -- caddr u)
\ return the S/N of the camera as a hex string
	base @ >R hex
	ASISN dup @(n) swap 4 + @(n) swap		\ S/N is stored in big-endian format
	(ud.)
	R> base !
;

: camera_pixels ( -- x y)
	ASICameraInfo ASI_MAX_WIDTH @
	ASICameraInfo ASI_MAX_HEIGHT @
;

: exposure_time ( -- caddr u)
\ return the exposure time in seconds as a string
	camera_exposure s>f
	1.0e6 f/
	fdup 30.0e0 f< if
		3 (f.)
	else
		0 (f.)
	then
;

: add-camera ( CameraID --)
\ make a camera available for application use
\ 	connect the camera and initialize it with a full frame
	dup ASIOpenCamera ASI.?abort
	dup ASIInitCamera ASI.?abort
	dup ASICameraInfo ( ID buffer) ASIGetCameraPropertyByID ASI.?abort
	camera_pixels 1 ( id width height bin) ASI_IMG_RAW16 ( ...16bit_unsigned) ASISetROIFormat ASI.?abort
;

: use-camera ( CameraID --)
\ choose the camera to be selected for operations, camera must be added first
	-> camera.ID
	camera.ID ASICameraInfo ( ID buffer) ASIGetCameraPropertyByID ASI.?abort
	camera.ID ASISN ASIGetSerialNumber ASI.?ABORT 
;

: remove-camera ( CameraID --)
\ disconnect the camera, it becomes unavailable to the application
	ASICloseCamera ASI.?abort
;

: scan-cameras ( -- )
\ scan the plugged-in cameras
\ create a CONSTANT (out of the name and S/N) for each CameraID
	ASIGetNumOfConnectedCameras ( -- n)
	?dup
	IF	\ loop over each connected camera
		CR ." ID" tab  ." Handle" tab tab ." Camera" CR
		0 do
			ASICameraInfo i ( buffer index) ASIGetCameraProperty  ASI.?abort
			ASICameraInfo ASI_CAMERA_ID @					( ID)
			dup -> camera.ID .	
			camera.ID ASIOpenCamera ASI.?abort	
			camera.ID ASISN ASIGetSerialNumber ASI.?ABORT 
			camera.ID ASI.make-handle 2dup tab type	( ID c-addr u)
			($constant)											( --)			
			camera_name tab type CR
			camera.ID ASICloseCamera ASI.?abort			
		loop
	ELSE
	CR ." No connected cameras" CR
	THEN
;

: exposure_status ( -- ASI_EXPOSURE_STATUS) { | exposureStatus }
\ return the exposure status of the camera
\ 		ASI_EXP_IDLE 		\ idle states, you can start exposure now
\ 		ASI_EXP_WORKING	\ exposing
\ 		ASI_EXP_SUCCESS	\ exposure finished and waiting for download
\ 		ASI_EXP_FAILED	
	camera.ID ADDR exposureStatus ASIGetExpStatus ASI.?abort
	exposureStatus
;

: wait-camera ( --)
\ synchronous hold while an exposure is underway
	BEGIN
		exposure_status ASI_EXP_WORKING =
	WHILE
		50 ms
	REPEAT
;

: start-exposure ( --)
\ initiate an exposure
	wait-camera
	camera.ID 0 ( ID isdark) ASIStartExposure ASI.?abort
;

: stop-exposure ( --)
\ stop an exposure as an exception
	camera.ID ASIStopExposure ASI.?abort
;

: download-image ( addr u --)
	wait-camera
	exposure_status ASI_EXP_SUCCESS = IF
		camera.ID -rot ( ID addr u) ASIGetDataAfterExp ASI.?abort
	ELSE
		abort" no image to download"
	THEN
;

\ convenience functions

: what-camera? ( --)
\ report the current camera to the user
	CR ." ID" 		camera.ID tab tab .	
	CR ." Name" 	camera_name tab tab type
	CR ." S/N"		camera_SN tab tab type
	CR ." Max_width"	camera_pixels swap tab . 
	CR ." Max_height" tab .
	CR ." Pixel_size" pixel_size tab type
	CR CR
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