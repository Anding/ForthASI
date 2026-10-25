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
: ASIGetControlValue ( id type value auto -- ior ) 2drop 2drop 1 ;
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
Tend
