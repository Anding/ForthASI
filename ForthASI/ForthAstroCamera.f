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
\
\ Maintenance: ASI ROI width and X origin align to 8 pixels; height and Y
\ origin align to 2.  subframe-at must expand after alignment so it never
\ clips the requested sensor region.

s" " $value asi.str1

ASI_GAIN                ASI.define-get-control camera_gain
ASI_GAIN                ASI.define-set-control ->camera_gain
ASI_EXPOSURE            ASI.define-get-control camera_exposure			\ uS
ASI_EXPOSURE            ASI.define-set-control	->camera_exposure		\ uS
ASI_OFFSET              ASI.define-get-control  camera_offset
ASI_OFFSET              ASI.define-set-control	->camera_offset
ASI_COOLER_POWER_PERC	ASI.define-get-control	cooler_power 
ASI_BANDWIDTHOVERLOAD	ASI.define-get-control	camera_bandwidth
ASI_BANDWIDTHOVERLOAD	ASI.define-set-control	->camera_bandwidth
ASI_TEMPERATURE			ASI.define-get-control	<camera_temperature>
ASI_TARGET_TEMP			ASI.define-get-control	target_temperature	\ C
ASI_TARGET_TEMP			ASI.define-set-control	->target_temperature	\ C
ASI_COOLER_ON           ASI.define-get-control	camera_cooler
ASI_COOLER_ON           ASI.define-set-control	->camera_cooler
ASI_ANTI_DEW_HEATER		ASI.define-get-control	camera_dew_heater
ASI_ANTI_DEW_HEATER		ASI.define-set-control	->camera_dew_heater
ASI_FAN_ON              ASI.define-get-control	camera_fan
ASI_FAN_ON              ASI.define-set-control	->camera_fan
ASI_HARDWARE_BIN        ASI.define-get-control	camera_hardware_bin
ASI_HARDWARE_BIN        ASI.define-set-control	->camera_hardware_bin

: camera_temperature
\ return the camera temperature in integer Celcius
	<camera_temperature> ( temp*10) 5 + 10 /
;

ASI_COOLER_ON 1 ASI.switch camera_cooler-on
ASI_COOLER_ON 0 ASI.switch camera_cooler-off
ASI_ANTI_DEW_HEATER 1 ASI.switch camera_dew_heater-on
ASI_ANTI_DEW_HEATER 0 ASI.switch camera_dew_heater-off
ASI_FAN_ON 1 ASI.switch camera_fan-on
ASI_FAN_ON 0 ASI.switch camera_fan-off
ASI_HARDWARE_BIN 1 ASI.switch hardware_bin-on
ASI_HARDWARE_BIN 0 ASI.switch hardware_bin-off

: camera_ROI ( -- width height bin) { | ROIWidth ROIHeight ROIBin ASIImgType }  \ VFX locals for pass-by-reference
	0 -> ROIWidth 0 -> ROIHeight 0 -> ROIBin 0 -> ASIImgType
	camera.ID ADDR ROIWidth ADDR ROIHeight ADDR ROIBin ADDR ASIImgType ASIGetROIFormat
	?dup if ASI.?abort 0 0 0 exit then
	ROIWidth ROIHeight ROIBin
;

: ->camera_ROI { width height bin -- }
    width 8 / 8 * -> width      \ width%8 == 0
    height 2 / 2 * -> height    \ height%2 ==0
 	camera.ID width height bin ASI_IMG_RAW16 ( 16bit unsigned) ASISetROIFormat ASI.?abort
;

: camera_ROI_start ( -- x y ) { | x y }
    0 -> x 0 -> y
    camera.ID ADDR x ADDR y ASIGetStartPos ?dup if ASI.?abort 0 0 exit then
    x y
;

: ->camera_ROI_start { x y -- }
    camera.ID x y ASISetStartPos ASI.?abort
;

: camera_binning ( -- bin)
\ return the camera binning
	camera_ROI nip nip
;

: ->camera_binning ( bin --)
\ set the camera binning
	camera_ROI 0= if 2drop drop exit then rot ->camera_ROI
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
	ASISN dup @ ( n) swap 4 + @ ( n) swap		\ S/N is stored in big-endian format
	(ud.)
	R> base !
;

: camera_pixels ( -- x y)
	ASICameraInfo ASI_MAX_WIDTH @
	ASICameraInfo ASI_MAX_HEIGHT @
;

: exposure_time ( -- caddr u)
\ return the exposure time in seconds as a string
	camera_exposure dup ( us)
	1000000 > if          \  over 1 second as an integer
	    1000000 /
	    (.)
	else                    
	    s>f
	    1.0e6 f/
	    3 (f.)
    then
;

: add-camera ( CameraID --)
\ make a camera available for application use
\ connect and initialize the SDK without explicitly applying configured controls
    ASIGetNumOfConnectedCameras 0= if drop s" no connected cameras" .E> exit then
	dup ASIOpenCamera ?dup if ASI.?abort drop exit then
	dup ASIInitCamera ?dup if ASI.?abort ASICloseCamera ASI.?abort exit then
	dup ASICameraInfo ASIGetCameraPropertyByID ?dup if
		ASI.?abort ASICloseCamera ASI.?abort exit
	then
	drop
;

: use-camera ( CameraID --)
\ choose the camera to be selected for operations, camera must be added first
	-> camera.ID
	camera.ID ASICameraInfo ASIGetCameraPropertyByID ?dup if ASI.?abort exit then
	camera.ID ASISN ASIGetSerialNumber ?dup if ASI.?abort exit then
	camera_name $-> asi.str1 s"  " $+> asi.str1 
	camera_pixels swap (.) $+> asi.str1 s"  x " $+> asi.str1 (.) $+> asi.str1 s"  pixels" $+> asi.str1  
	asi.str1 .>
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
			ASICameraInfo i ASIGetCameraProperty ?dup if ASI.?abort unloop exit then
			ASICameraInfo ASI_CAMERA_ID @					( ID)
			dup -> camera.ID .	
			camera.ID ASIOpenCamera ?dup if ASI.?abort unloop exit then
			camera.ID ASISN ASIGetSerialNumber ?dup if
				ASI.?abort camera.ID ASICloseCamera ASI.?abort unloop exit
			then
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
	ASI_EXP_FAILED -> exposureStatus
	camera.ID ADDR exposureStatus ASIGetExpStatus ?dup if ASI.?abort ASI_EXP_FAILED exit then
	exposureStatus
;

: (wait-camera-free) ( -- status )
\ Return the terminal exposure status; a failed SDK read ends this wait.
	BEGIN
		exposure_status dup ASI_EXP_WORKING =
	WHILE
		drop 50 ms
	REPEAT
;

: wait-camera-free ( -- )
\ Synchronously wait until the camera is free, reporting SDK errors.
	(wait-camera-free) drop
;

: wait-camera-finished ( --)
\ synchronous hold until the camera is finished exposing
	(wait-camera-free) ASI_EXP_SUCCESS <> if s" Exposure failed or absent" .E> then
;	

: (start-exposure) ( -- started? )
\ Report the SDK result and tell acquisition whether the exposure started.
	camera.ID 0 ( ID isdark) ASIStartExposure dup ASI.?abort 0=
;

: start-exposure ( -- )
\ Initiate an exposure and report errors; retain the interactive stack effect.
	(start-exposure) drop
;

: start-dark-exposure ( --)
\ initiate an exposure marked as a dark frame by the camera driver
    camera.ID -1 ( ID isdark) ASIStartExposure ASI.?abort
;

: stop-exposure ( --)
\ stop an exposure
	camera.ID ASIStopExposure ASI.?abort
;

: (download-image) ( addr u -- downloaded? )
\ Return true only when exposure completion and the SDK download both succeed.
	(wait-camera-free) ASI_EXP_SUCCESS = IF
		camera.ID -rot ( ID addr u) ASIGetDataAfterExp dup ASI.?abort 0=
	ELSE
		2drop s" no image to download" .E> false
	THEN
;

: download-image ( addr u -- )
\ Download pixels and report errors; retain the interactive stack effect.
	(download-image) drop
;

\ user lexicon

: check-camera { | width height bin -- }
\ report the current camera to the user
	camera.ID ASICameraInfo ASIGetCameraPropertyByID ?dup if ASI.?abort exit then
	camera_ROI -> bin -> height -> width
	s" Camera" panel{
	s" ID" camera.ID (.) .field
	s" Name" camera_name .field
	s" Gain" camera_gain (.) .field
	s" Offset" camera_offset (.) .field
	s" Exposure (us)" camera_exposure (.) .field
	width (.) $-> asi.str1
	s"  x " $+> asi.str1
	height (.) $+> asi.str1
	s"  bin " $+> asi.str1
	bin (.) $+> asi.str1
	s" ROI" asi.str1 .field
	s" Temperature (C)" camera_temperature (.) .field
	}panel
;

\ convert uS to uS
\ for syntax consistency only
synonym uSecs noop ( uS -- uS )

: mSecs ( mS -- uS)
\ convert uS to mS
	1000 *
;

: Secs ( S -- uS)
\ convert S to uS
	1000000 *
;

\ set the exposure duration
synonym duration ->camera_exposure ( us -- )

: subframe-at
    { x y width height |
      sensor-width sensor-height aligned-x aligned-y -- }
\ Align the origin and expand the ROI so it still encloses the request.
    camera_pixels -> sensor-height -> sensor-width
    sensor-width 0> sensor-height 0> and 0= if
        s" No camera sensor dimensions" .E> exit
    then
    width 7 + 8 / 8 * sensor-width 8 / 8 * min -> width
    height 1+ 2 / 2 * sensor-height 2 / 2 * min -> height
    x 0 max sensor-width width - min -> x
    y 0 max sensor-height height - min -> y
    x 8 / 8 * -> aligned-x
    y 2 / 2 * -> aligned-y
    width x aligned-x - + 7 + 8 / 8 *
        sensor-width aligned-x - min -> width
    height y aligned-y - + 1+ 2 / 2 *
        sensor-height aligned-y - min -> height
    camera.ID width 8 / 8 * height 2 / 2 * 1 ASI_IMG_RAW16 ASISetROIFormat
        ?dup if ASI.?abort exit then
    aligned-x aligned-y ->camera_ROI_start
;

: fullframe ( --)
\ set the camera to take full-frame images, and binning to 1
    0 0 camera_pixels subframe-at
;

: subframe { p | sensor-width sensor-height size x y -- }
\ set the subframe to a square p% of the smaller camera dimension, and binning to 1
    camera_pixels -> sensor-height -> sensor-width
    sensor-width sensor-height min p * 100 / -> size
    sensor-width size - 2/ -> x
    sensor-height size - 2/ -> y
    x y size size subframe-at
;
    
    
