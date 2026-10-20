\ Hardware-free regression: camera metadata must not consume caller data.
NEED ForthBase
NEED ordered-maps
NEED simple-tester

: camera_ROI ( -- width height bin ) 6248 4176 1 ;
: camera_ROI_start ( -- x y ) 16 32 ;
20 constant camera_offset
240000000 constant camera_exposure
: exposure_time ( -- caddr u ) s" 240" ;
: effective_pixel_size ( -- caddr u ) s" 3.760" ;
: camera_name ( -- caddr u ) s" ZWO ASI2600MM Pro" ;
: camera_SN ( -- caddr u ) s" 09501F0300090120" ;
: electrons_per_adu ( -- caddr u ) s" 0.243" ;
30 constant camera_temperature
-10 constant target_temperature
1 constant camera_cooler
50 constant cooler_power
0 constant camera_fan
0 constant camera_dew_heater
40 constant camera_bandwidth
100 constant camera_gain

include "%idir%\ForthAstroCameraMaps.f"

allocate-map constant camera-test-map

Tstart

T{ 1234 camera-test-map add-cameraFITS }T 1234 ==
T{ camera-test-map map-count }T 32 ==
T{ s" NAXIS1" camera-test-map map@ hashS }T s" 6248" hashS ==
T{ s" NAXIS2" camera-test-map map@ hashS }T s" 4176" hashS ==
T{ s" XORGSUBF" camera-test-map map@ hashS }T s" 16" hashS ==
T{ s" YORGSUBF" camera-test-map map@ hashS }T s" 32" hashS ==
T{ s" XBINNING" camera-test-map map@ hashS }T s" 1" hashS ==
T{ s" YBINNING" camera-test-map map@ hashS }T s" 1" hashS ==
T{ s" EXPOINUS" camera-test-map map@ hashS }T s" 240000000" hashS ==
T{ s" EXPOINMS" camera-test-map map@ hashS }T s" 240000" hashS ==
T{ s" OFFSET" camera-test-map map@ hashS }T s" 20" hashS ==

T{ 1234 camera-test-map reset-map }T 1234 ==
T{ camera-test-map map-count }T 32 ==
T{ s" NAXIS1" camera-test-map map@ }T 0 0 ==
T{ 1234 camera-test-map add-cameraFITS }T 1234 ==
T{ camera-test-map map-count }T 32 ==
T{ s" NAXIS1" camera-test-map map@ hashS }T s" 6248" hashS ==
T{ 1234 camera-test-map erase-map }T 1234 ==
T{ camera-test-map map-count }T 0 ==
T{ s" OFFSET" camera-test-map map@ }T 0 0 ==
T{ 1234 camera-test-map add-cameraFITS }T 1234 ==
T{ camera-test-map map-count }T 32 ==

camera-test-map free-map

Tend
