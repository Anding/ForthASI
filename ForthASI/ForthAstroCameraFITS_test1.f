\ test for ForthAstroCameraFITS.f

include "%idir%\..\..\ForthBase\ForthBase.f"
include "%idir%\ASI_SDK.f"
include "%idir%\ASI_SDK_extend.f"
include "%idir%\ForthAstroCamera.f"
include "%idir%\..\..\ForthBase\serial\VFX32serial.f"
include "%idir%\..\..\ForthKMTronic\KMTronic_Bidmead.f"
include "%idir%\..\..\ForthKMTronic\KMTronic.f"
include "%idir%"\..\..\forth-map\map.fs"
include "%idir%"\..\..\forth-map\map-tools.fs"
include "%idir%\ForthAstroCameraFITS.f"

-1 constant power-is-relay-switched
CR

power-is-relay-switched [IF] 
\ Switch on the camera relay

	6 constant COM-KMTronic
	COM-KMTronic add-relays
	1 relay-on
	3000 ms
	." Relay power on" CR
[THEN]

scan-cameras
0 add-camera
0 use-camera
500 ms

	map-strings
	map CONSTANT camera_FITSmap
	camera_FITSmap add-cameraFITS
	camera_FITSmap .map
	
		map-strings
	map CONSTANT camera_map
	camera_XISFmap add-cameraXISF
	camera_XISFmap .map

power-is-relay-switched [IF]
\ Switch off the camera relay

	500 ms
	1 relay-off
	CR ." Relay power off" CR

	remove-relays
	
[THEN]