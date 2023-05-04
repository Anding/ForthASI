// CameraTest1.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include <stdio.h>
#include "ASICamera2.h"
// ASICamera2.lib accompanies ASICamera2.h and is added to Resource Files in VS
// ASICamera2.dll is placed into the folder with the executable, e.g.
// E:\coding\ForthASI\CameraTest1\x64\Debug

int main()
{
    int numCameras = 0 ;

    printf("Hello World!\n");
    printf("sizeof(int): %d bytes\n", (int)sizeof(int)); // 4
    printf("sizeof(long): %d bytes\n", (int)sizeof(long)); // 4
    printf("sizeof(float): %d bytes\n", (int) sizeof(float)); // 4
    printf("sizeof(double): %d bytes\n", (int) sizeof(double)); // 8  BUT camera returns 12 bytes!
    printf("sizeof(ASI_BOOL): %d bytes\n", (int)sizeof(ASI_BOOL)); // 4
    printf("sizeof(ASI_BAYER_PATTERN): %d bytes\n", (int)sizeof(ASI_BAYER_PATTERN)); // 4  
    printf("sizeof(ASI_IMG_TYPE): %d bytes\n", (int)sizeof(ASI_IMG_TYPE)); // 4  
    printf("sizeof(ASI_CAMERA_INFO): %d bytes\n", (int) sizeof(ASI_CAMERA_INFO)); // 8
    printf("sizeof(ASI_CONTROL_CAPS): %d bytes\n", (int)sizeof(ASI_CONTROL_CAPS)); // 8
    printf("sizeof(ASI_ID): %d bytes\n", (int)sizeof(ASI_ID)); // 8
    printf("\n");

    printf("enum ASI_ANTI_DEW_HEATER : %d\n", ASI_ANTI_DEW_HEATER);
    
    printf("\n");
    numCameras = ASIGetNumOfConnectedCameras();
    printf("ASIGetNumOfConnectedCameras() returns int: %d\n", numCameras);
    printf("\n\n");
}

// Run program: Ctrl + F5 or Debug > Start Without Debugging menu
// Debug program: F5 or Debug > Start Debugging menu

// Tips for Getting Started: 
//   1. Use the Solution Explorer window to add/manage files
//   2. Use the Team Explorer window to connect to source control
//   3. Use the Output window to see build output and other messages
//   4. Use the Error List window to view errors
//   5. Go to Project > Add New Item to create new code files, or Project > Add Existing Item to add existing code files to the project
//   6. In the future, to open this project again, go to File > Open > Project and select the .sln file
