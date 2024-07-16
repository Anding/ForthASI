\ test for ForthAstroCamera.f

include "%idir%\..\..\ForthBase\ForthBase.f"
include "%idir%\ASI_SDK.f"
include "%idir%\ASI_SDK_extend.f"
include "%idir%\ForthAstroCamera.f"
include "%idir%\ForthKMTronic\ForthKMTronic.f"

-1 constant power-is-relay-switched

power-is-relay-switched [IF] 
\ Switch on the camera relay

	6 constant COM-KMTronic
	COM-KMTronic add-relays
	1 relay-on
	2000 ms
	
[THEN]

CR
scan-cameras

power-is-relay-switched [IF]
\ Switch off the camera relay

	2000 ms
	1 relay-off

	remove-relays
	
[THEN]