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

BEGIN-STRUCTURE CAMERA_INFO
 4 +FIELD CAMERA_ID		\ ASI Camera ID
64 +FIELD CAMERA_NAME
 4 +FIELD MAX_HEIGHT
 4 +FIELD MAX_WIDTH
 8 +FIELD SERIAL_NO
END-STRUCTURE

: cam.define ( CAMERA_INFO <NAME> --)
\ defining word to recognze a connected camera
	create
		CAMERA_INFO allot
	does>
	
 
value 0 cam.ID 
\ the ASI CameraID of the presently selected camera

: plugged-cameras? ( -- )
\ list the plugged-in cameras
\ SerialNo Name ASICameraID MaxWidth MaxHeight
;

: add-camera ( SerialNo --)
\ make a camera available for application use and return it's Application Camera Number
\ 	connect the camera and initialize it with a full frame
\ 	requires that plugged-cameras? has been run already
\ 	SerialNo is matched to the last 6 digits only
;

: remove-camera ( SerialNo --)
\ disconnect the camera, it becomes unavailable to the application
;

: use-camera ( SerialNo --)
\ set the presently-selected camera
;

: what-camera? ( --)
\ report the presently-selected camera to the user
\ CameraNo Name ASICameraID UniqueID MaxWidth MaxHeight
;

: camera_gain ( -- gain)
\ return the gain of the presently-selected camera
;

: ->camera_gain ( gain --)
\ set the gain of the presently-selected cammara
;

: uSeconds ( uS -- uS)
\ convert uS to uS
\ for documentation only
;

: mSeconds ( mS -- us)
\ convert uS to mS
	1000 *
;

: Seconds( S -- uS)
\ convert S to uS
	1000000 *
;

: exposure ( -- exposure_in_uS )
\ return the exposure in uS of the presently-selected camera
\ 	does not initiate an image
;

: ->exposure ( exposure_in_uS --)
\ set the exposure in uS of the presently-selected camera
;


