// ASIClientTest1.cpp : This file contains the 'main' function. Program execution begins and ends there.
//


#include <stdio.h>
#include "ASILibraryTest1.h"


int main()
{
    int numCameras = 0;

    printf("Hello World!\n");
    numCameras = ConnectedCameraCount();
    printf("ASIGetNumOfConnectedCameras() returns int: %d\n", numCameras);
}
