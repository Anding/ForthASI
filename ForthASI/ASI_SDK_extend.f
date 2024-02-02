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

: ASI.camera_model ( c-addr u -- c-addr u)
\ extract the model of an ASI camera from the ASI_CAMERA_NAME field
\ assume that the name is formatted "ZWO ASI[MODEL]"
	4 - swap 4 + swap
	2dup despace
;

: ASI.make-handle ( -- c-addr u)
\ prepare a handle for the camera based on name and serial number
\ assumes ASIGetCameraProperty and ASIGetSerialNumber have been called
	base @ >R hex	\ s/n in hexadecimal
	ASISN l@ 0 
	<# # # # #  	\ last 4 digits only 
	'_' HOLD			\ separator
	ASICameraInfo ASI_CAMERA_NAME zcount ASI.camera_model HOLDS
	#> 
	R> base !
;

: ASI.get-control ( CameraID ASI_CONTROL_TYPE -- value) {  | ControlV ControlA -- } \ VFX unassigned locals
	ADDR ControlV ADDR ControlA ( ID ASI_CONTROL_TYPE &ControlValue &ControlAuto) ASIGetControlValue ASI.?Abort
	ControlV
;

: ASI.set-control ( CameraID ASI_CONTROL_TYPE value --)
	0 ( ID ASI_CONTROL_TYPE ControlValue ControlAuto) ASISetControlValue ASI.?Abort
;
 
0 value camera.ID 
\ the ASI CameraID of the presently selected camera

: ASI.define-get-control
	CREATE ( ASI_CONTROL_TYPE)
		,
	DOES>
	@ camera.ID swap
	ASI.get-control
;

: ASI.define-set-control
	CREATE ( ASI_CONTROL_TYPE) 
		,
	DOES> ( value &PFA)
	@ camera.ID	-rot swap ( CameraID ASI_CONTROL_TYPE value)
	ASI.set-control
;


		