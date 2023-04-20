CR
LIBRARY: ASILibraryTest1.dll							\ place all DLL files in the VFX executable directory e.g. C:\MPE\VfxForth64\Bin
EXTERN: int "C" ConnectedCameraCount( void ) ;	\ nota bene the space before the ;

." ASILibraryTest1.dll load address "
ASILibraryTest1.dll u. CR

." ConnectedCameraCount load address "
' ConnectedCameraCount func-loaded? u. CR

.BadExterns CR

." ConnectedCameraCount is "
ConnectedCameraCount . CR