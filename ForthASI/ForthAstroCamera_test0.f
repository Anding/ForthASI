\ test for ForthAstroCamera.f

include "%idir%\..\..\ForthBase\libraries\libraries.f"
NEED forthbase
NEED simple-tester

include "%idir%\ASI_SDK.f"
: ASIGetControlValue ( id type value auto -- ior ) 2drop 2drop 1 ;
: ASIGetExpStatus ( id status -- ior ) ASI_EXP_SUCCESS swap ! drop 1 ;
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
Tend
