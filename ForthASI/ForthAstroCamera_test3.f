\ test for ForthAstroCamera.f

include "%idir%\..\..\ForthBase\libraries\libraries.f"
NEED forthbase
NEED network
NEED serial
NEED ForthKMTronic

include "%idir%\ASI_SDK.f"
include "%idir%\ASI_SDK_extend.f"
include "%idir%\ForthAstroCamera.f"

-1 constant power-is-relay-switched
CR

power-is-relay-switched [IF] 
\ Switch on the camera relay

	add-relays
	1 relay-on
	500 ms
	." Relay power on" CR
[THEN]

BEGIN-ENUMS $exposure_status
	+" ASI_EXP_IDLE" 		
	+" ASI_EXP_WORKING"	
	+" ASI_EXP_SUCCESS"
	+" ASI_EXP_FAILED"
END-ENUMS 

scan-cameras
ASI2600MM_031F add-camera
ASI2600MM_031F use-camera
500 ms

camera_pixels 2 * * CONSTANT image_size
image_size allocate drop CONSTANT image_buffer

1000000 ->camera_exposure
CR ." exposure_status :" exposure_status $exposure_status type
start-exposure
CR ." exposure_status :" exposure_status $exposure_status type 
wait-camera
CR ." exposure_status :" exposure_status $exposure_status type 
CR image_buffer image_size download-image ." downloaded"
CR ." exposure_status :" exposure_status $exposure_status type 

power-is-relay-switched [IF]
\ Switch off the camera relay

	500 ms
	1 relay-off
	CR ." Relay power off" CR

	remove-relays
	
[THEN]