\ test for ForthAstroCamera.f

include "%idir%\..\..\ForthBase\libraries\libraries.f"
NEED forthbase
NEED simple-tester

include "%idir%\ASI_SDK.f"
1 value test.status-error
ASI_EXP_SUCCESS value test.status
1 value test.start-error
1 value test.download-error
0 value test.downloads
1 value test.control-error
0 value test.control-value
: ASIGetControlValue { id control value auto -- ior }
\ Supply signed SDK control readings without a camera.
    test.control-value value ! 0 auto ! test.control-error ;
ASI_IMG_RAW8 value test.format
0 value test.roi-width
0 value test.roi-height
0 value test.roi-bin
: ASIGetROIFormat { id width height bin format -- ior }
\ Simulate a cropped, binned camera initially left in RAW8.
    640 width ! 480 height ! 2 bin ! test.format format ! 0 ;
: ASISetROIFormat { id width height bin format -- ior }
\ Record the selected pixel format and geometry.
    width -> test.roi-width height -> test.roi-height
    bin -> test.roi-bin format -> test.format 0 ;
: ASIGetCameraPropertyByID ( id info -- ior )
\ Supply a minimal camera description without opening a device.
    dup ASI_CAMERA_INFO erase 2drop 0 ;
: ASIGetSerialNumber ( id serial -- ior )
\ Supply a zero serial number for the simulated camera.
    dup 8 erase 2drop 0 ;
: ASIGetExpStatus ( id status -- ior )
\ A one-off failed status read must not be hidden by a second successful query.
    test.status swap ! drop test.status-error 0 -> test.status-error ;
: ASIStartExposure ( id dark? -- ior )
\ Inject the native start result without opening a camera.
    2drop test.start-error ;
: ASIGetDataAfterExp ( id bitmap bytes -- ior )
\ Count attempts separately from SDK download success.
    drop 2drop test.downloads 1+ -> test.downloads test.download-error ;
create test.pixels 16 allot
0 value test.setting
: ASISetControlValue ( id control value auto -- ior )
    drop rot drop 100 * + -> test.setting 1
;
include "%idir%\ASI_SDK_extend.f"
include "%idir%\ForthAstroCamera.f"

Tstart
T{ 123 1 ASI.?abort }T 123 ==
T{ 123 camera_gain exposure_status }T 123 0 ASI_EXP_FAILED ==
T{ 123 camera_cooler-on test.setting }T 123 ASI_COOLER_ON 100 + ==
T{ 123 hardware_bin-off test.setting }T 123 ASI_HARDWARE_BIN ==

\ Checked entry points distinguish SDK failure from success; interactive ones consume flags.
T{ 123 (start-exposure) }T 123 false ==
T{ 123 start-exposure }T 123 ==
0 -> test.start-error
T{ 123 (start-exposure) }T 123 true ==
1 -> test.status-error
T{ test.pixels 16 (download-image) test.downloads }T false 0 ==
0 -> test.status-error ASI_EXP_FAILED -> test.status
T{ test.pixels 16 (download-image) test.downloads }T false 0 ==
ASI_EXP_SUCCESS -> test.status
T{ test.pixels 16 (download-image) test.downloads }T false 1 ==
0 -> test.download-error
T{ test.pixels 16 (download-image) test.downloads }T true 2 ==
T{ 123 test.pixels 16 download-image }T 123 ==

\ Cooling below zero must not introduce truncation towards zero after rounding.
0 -> test.control-error
271 -> test.control-value
T{ camera_temperature }T 27 ==
-6 -> test.control-value
T{ camera_temperature }T -1 ==
-14 -> test.control-value
T{ camera_temperature }T -1 ==
-15 -> test.control-value
T{ camera_temperature }T -2 ==

\ Selecting a camera establishes RAW16 without applying fullframe or bin-one.
T{ 0 use-camera }T ==
T{ test.format test.roi-width test.roi-height test.roi-bin }T ASI_IMG_RAW16 640 480 2 ==
Tend
