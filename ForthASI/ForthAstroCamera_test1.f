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

what-camera?

: review-camera
	." camera_gain " camera_gain . CR
	." camera_exposure " camera_exposure . CR
	." camera_offset " camera_offset . CR
	." cooler_power " cooler_power . CR
	." camera_bandwidth " camera_bandwidth . CR
	." camera_temperature " camera_temperature . CR
	." target_temperature " target_temperature . CR
	." camera_cooler " camera_cooler . CR
	." camera_dew_heater " camera_dew_heater . CR
	." camera_fan " camera_fan . CR 
	." camera_hardware_bin " camera_hardware_bin . CR
;

review-camera

CR ." Set some controls" CR
	200 ->camera_gain
	1000 ->camera_exposure
	100 ->camera_offset
	80 ->camera_bandwidth
	-5 ->target_temperature
	cooler-on
	fan-on
	dew_heater-on
	hardware_bin-on

review-camera


power-is-relay-switched [IF]
\ Switch off the camera relay

	500 ms
	1 relay-off
	CR ." Relay power off" CR

	remove-relays
	
[THEN]