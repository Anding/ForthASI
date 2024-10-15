\ test for ForthAstroCameraFITS.f

include "%idir%\..\..\ForthBase\libraries\libraries.f"
NEED forthbase
NEED network
NEED serial
NEED ForthKMTronic
NEED forth-map
NEED windows

include "%idir%\ASI_SDK.f"
include "%idir%\ASI_SDK_extend.f"
include "%idir%\ForthAstroCamera.f"
include "%idir%\ForthAstroCameraMaps.f"

-1 constant power-is-relay-switched
CR

power-is-relay-switched [IF] 
\ Switch on the camera relay

	add-relays
	1 relay-on
	3000 ms
	." Relay power on" CR
[THEN]

scan-cameras
ASI2600MM_031F add-camera
ASI2600MM_031F use-camera
500 ms

	map-strings
	map CONSTANT camera_FITSmap
	camera_FITSmap add-cameraFITS
	camera_FITSmap .map
	
	map CONSTANT camera_XISFmap
	camera_XISFmap add-cameraXISF
	camera_XISFmap .map

power-is-relay-switched [IF]
\ Switch off the camera relay

	500 ms
	1 relay-off
	CR ." Relay power off" CR

	remove-relays
	
[THEN]