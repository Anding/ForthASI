ForthASI next steps
===================

1. ```ForthAstroCameraFITS.f``` to populate a forth-map with FITS keys for XISF files

	- Use the MaxIMDL FITS keyword set	
	- Include all camera properties, name, S/N, exposure, offset, gain, temperature, etc. in a separate json file, tied with a SSID
	
2. Implement 64 bit S/N by using double fetch and ud. (also in EFW)

3. Factor out the reporting in scan-cameras and which-camera?

4. Thoughts towards domain-specific language?

5. How to display camera properties in a window with VFX?  E.g.:

	- Direct output to a VT100 emulator, specifically running VFX Forth in Windows Terminal

6. Further benchtesting with cameras and testing with image
	