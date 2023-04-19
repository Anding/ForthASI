#pragma once

#ifdef ASILIBRARYTEST1_EXPORTS
#define ASILIBRARYTEST1_API __declspec(dllexport)
#else
#define ASILIBRARYTEST1_API __declspec(dllimport)
#endif

// Return the number of connected cameras
ASILIBRARYTEST1_API int ConnectedCameraCount();
