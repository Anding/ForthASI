\ test for ForthAstroCamera.f

include "%idir%\..\..\ForthBase\ForthBase.f"
include "%idir%\ASI_SDK.f"
include "%idir%\ASI_SDK_extend.f"
include "%idir%\ForthAstroCamera.f"
include "%idir%\..\..\ForthKMTronic\KMTronic.f"

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

ASICameraInfo CR ." ASI_CAMERA_NAME " ASI_CAMERA_NAME 64 dump
ASICameraInfo CR ." ASI_CAMERA_ID " ASI_CAMERA_ID 4 dump 
ASICameraInfo CR ." ASI_MAX_HEIGHT " ASI_MAX_HEIGHT 4 dump
ASICameraInfo CR ." ASI_MAX_WIDTH " ASI_MAX_WIDTH 4 dump
ASICameraInfo CR ." ASI_IS_COLOR_CAM " ASI_IS_COLOR_CAM 4 dump
ASICameraInfo CR ." ASI_BAYER_PATTERN " ASI_BAYER_PATTERN 4 dump
ASICameraInfo CR ." ASI_SUPPORTED_BINS " ASI_SUPPORTED_BINS 64 dump
ASICameraInfo CR ." ASI_SUPPORTED_VIDEO_FORMAT " ASI_SUPPORTED_VIDEO_FORMAT 32 dump
ASICameraInfo CR ." ASI_PIXEL_SIZE " ASI_PIXEL_SIZE 12 dump				
ASICameraInfo CR ." ASI_MECHANICAL_SHUTTER " ASI_MECHANICAL_SHUTTER 4 dump
ASICameraInfo CR ." ASI_ST4_PORT " ASI_ST4_PORT 4 dump
ASICameraInfo CR ." ASI_IS_COOLER_CAM " ASI_IS_COOLER_CAM 4 dump
ASICameraInfo CR ." ASI_IS_USB3 " ASI_IS_USB3 4 dump
ASICameraInfo CR ." ASI_ELEC_PER_ADU " ASI_ELEC_PER_ADU 4 dump				
ASICameraInfo CR ." ASI_BIT_DEPTH " ASI_BIT_DEPTH 4 dump
ASICameraInfo CR ." ASI_IS_TRIGGER_CAM " ASI_IS_TRIGGER_CAM 4 dump
ASICameraInfo CR ." ASI_PIXEL_SIZE_SHORT " ASI_PIXEL_SIZE_SHORT 4 dump
ASICameraInfo CR ." ASI_CAMERA_INFO_UNUSED " ASI_CAMERA_INFO_UNUSED 12 dump

	CR
	CR ." pixel_size " pixel_size type
	CR ." effective_pixel_size " effective_pixel_size type
	CR ." electrons_per_ADU " electrons_per_ADU type
	CR ." exposure_time " exposure_time type
	CR


power-is-relay-switched [IF]
\ Switch off the camera relay

	500 ms
	1 relay-off
	CR ." Relay power off" CR

	remove-relays
	
[THEN]