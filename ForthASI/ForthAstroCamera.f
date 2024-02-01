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

 
0 value camera.ID 
\ the ASI CameraID of the presently selected camera

: scan-cameras ( -- )
\ scan the plugged-in cameras
\ create a CONSTANT (out of the name and S/N) for each CameraID
\ report the cameras and 
	base @ >R hex									\ report the s/n in hex
	ASIGetNumOfConnectedCameras ( -- n)
	?dup
	IF
		\ loop over each connected camera
		CR ." ID" tab ." Camera" tab tab ." S/N" tab tab ." Handle" CR
		0 do
			ASICameraInfo i ( buffer index) ASIGetCameraProperty  ASI.?abort
			ASICameraInfo ASI_CAMERA_ID l@				( ID)
			dup .
			ASICameraInfo ASI_CAMERA_NAME zcount tab type			
			dup ASIOpenCamera ASI.?ABORT
			dup ASISN ASIGetSerialNumber ASI.?ABORT 	( ID)
			dup ASICloseCamera ASI.?abort					( ID)
			ASISN l@ tab u. 									\ last 8 hex digits only				
			ASI.make-handle									( ID c-addr u)
			2dup tab type CR									( ID c-addr u)
			($constant)											( --)
		loop
	THEN
	R> base !
;

: add-camera ( CameraID --)
\ make a camera available for application use
\ 	connect the camera and initialize it with a full frame
	dup ASIOpenCamera ASI.?abort
	dup ASIInitCamera ASI.?abort
	dup ASICameraInfo ( ID buffer) ASIGetCameraPropertyByID ASI.?abort
	( ID) ASICameraInfo ASI_MAX_WIDTH l@ ASICameraInfo ASI_MAX_HEIGHT l@ 1 ( width height bin) ASI_IMG_RAW16 ( 16bit unsigned) ASISetROIFormat ASI.?abort
;

: remove-camera ( CameraID --)
\ disconnect the camera, it becomes unavailable to the application
	ASICloseCamera ASI.?abort
;

: select-camera ( CameraID --)
\ choose the camera to be selected for operations
	-> camera.ID
;

: what-camera? ( --)
\ report the current camera to the user
\ CameraID Name SerialNo MaxWidth MaxHeight
	CR ." ID" tab ." Camera" tab tab ." S/N" tab tab ." Max_Width" tab ." Max_Height" CR	
	camera.ID .	
	camera.ID ASICameraInfo ( ID buffer) ASIGetCameraPropertyByID ASI.?abort
	camera.ID ASISN ASIGetSerialNumber ASI.?ABORT 
	ASICameraInfo ASI_CAMERA_NAME zcount tab type
	base @ hex									\ report the s/n in hex
	ASISN l@ tab u.
	base !
	ASICameraInfo ASI_MAX_WIDTH l@ tab .
	ASICameraInfo ASI_MAX_HEIGHT l@ tab tab . CR
;

: camera_gain ( -- gain)
\ return the gain of the camera
	camera.ID ASI_GAIN ASI.get-control
;

: ->camera_gain ( gain --)
\ set the gain of the camera
	camera.ID ASI_GAIN rot 
	( CameraID ASI_CONTROL_TYPE value) ASI.set-control
;

: camera_exposure ( -- exposure_in_uS)
\ return the exposure in uS of the camera
\ 	does not initiate an image
;

: ->camera_exposure ( exposure_in_uS --)
\ set the exposure in uS of the camera
;

: camera_temp ( -- temperature_in_C)
\ return the temperature of the camera
;

: ->camera_temp_target ( temperature_in_C --)
\ set the temperature of the camera
;

: camera_offset ( -- offset_in_ADU)
\ return the offset of the camera
;

: ->camera_offset ( offset_in_ADU --)
\ set the offset of the camera
;

: camera_binning ( -- x)
\ return the camera binning
;

: ->camera_binning ( x --)
\ set the camera binning
;

: ->camera_restrict ( n -- width height)
\ restrict the camera to 1/n of full frame size, centred
\ return the width and height of the frame size set
;

: start-cooling ( --)
\ start the camera cooler
;

: stop-cooling ( --)
\ stop the camera cooler
;

: uSeconds ( uS -- uS)
\ convert uS to uS
\ for documentation only
;

: mSeconds ( mS -- uS)
\ convert uS to mS
	1000 *
;

: Seconds ( S -- uS)
\ convert S to uS
	1000000 *
;
