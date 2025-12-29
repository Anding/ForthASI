\ utilities and helper functions to conveniently operate the ASI SDK
\ requires ASI_SDK.f

\ Lexicon conventions
\ 	ASI.word

\ Operational notes
\ 	variables over values

: despace ( c-addr u --)
\ convert spaces to underscore characters
	over + swap do
		i c@ BL = if '_' i c! then	
	loop
;

: ASI.get-model ( c-addr u -- c-addr u)
\ extract the model of an ASI camera from the ASI_CAMERA_NAME field
\ assume that the name is formatted "ZWO ASI[MODEL]"
	4 - swap 4 + swap
	2dup despace 
	9 min				\ limit to 9 characters in the model	
;

: ASI.make-handle ( -- c-addr u)
\ prepare a handle for the camera based on name and serial number
\ assumes ASIGetCameraProperty and ASIGetSerialNumber have been called
	base @ >R hex	\ s/n in hexadecimal
	ASISN w@ ( n) 0 
	<# # # # #  	\ first 4 digits only 
	'_' HOLD			\ separator
	ASICameraInfo ASI_CAMERA_NAME zcount ASI.get-model HOLDS
	#> 
	R> base !
;

: ASI.get-control ( CameraID ASI_CONTROL_TYPE -- value) {  | ControlValue ControlAuto -- } \ VFX unassigned locals
	ADDR ControlValue ADDR ControlAuto ( ID ASI_CONTROL_TYPE &ControlValue &ControlAuto) ASIGetControlValue 
	case
		0 of ControlValue endof
		3 of 0 exit 		endof \ invalid control type, just return 0
		dup ASI.?Abort
	endcase
;

: ASI.set-control ( CameraID ASI_CONTROL_TYPE value --)
	0 ( ID ASI_CONTROL_TYPE ControlValue ControlAuto) ASISetControlValue ASI.?Abort
;
 
0 value camera.ID 
\ the ASI CameraID of the presently selected camera

: ASI.define-get-control
\ defining word for wrapping ASI.get-control
	CREATE ( ASI_CONTROL_TYPE <NAME> --)
		,
	DOES> ( -- value)
	( PFA) @ camera.ID swap
	ASI.get-control
;

: ASI.define-set-control
\ defining word for wrapping ASI.set-control
	CREATE ( ASI_CONTROL_TYPE <NAME> --) 
		,
	DOES> ( value --)
	( value PFA) @ camera.ID	-rot swap ( CameraID ASI_CONTROL_TYPE value)
	ASI.set-control
;





		