// Must set properties/Precompiled Headers / Precompiled Header / Not using...
#include "ASILibraryTest1.h"
#include "ASICamera2.h"
// ASICamera2.lib accompanies ASICamera2.h and is added to Resource Files in VS
// ASICamera2.dll is placed into the folder with the executable, e.g. ...\x64\Debug

unsigned int ConnectedCameraCount()
{
    int numCameras = 0;
    numCameras = ASIGetNumOfConnectedCameras();

    return numCameras;
    
}