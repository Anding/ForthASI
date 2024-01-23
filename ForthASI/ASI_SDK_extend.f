\ utilities and helper functions to conveniently operate the ASI SDK
\ requires ASI_SDK.f

\ Lexicon conventions
\ 	ASI.word

\ Operational notes
\ 	variables over values

: ASI.camera_model ( c-addr u -- c-addr u)
\ extract the model of an ASI camera from the ASI_CAMERA_NAME field
\ assume that the name is formatted "ZWO ASI[MODEL]"
	4 - swap 4 + swap
;

: ASI.make-handle ( -- c-addr u)
\ prepare a handle for the camera based on name and serial number
\ assumes ASIGetCameraProperty and ASIGetSerialNumber have been called
	base @ >R hex	\ s/n in hexadecimal
	ASISN l@ 0 
	<# # # # #  	\ last 4 digits only 
	ASICameraInfo ASI_CAMERA_NAME zcount ASI.camera_model HOLDS
	#> 
	R> base !
;