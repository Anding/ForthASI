ForthASI next steps
===================

1. ```ForthAstroCameraFITS.f``` to populate a forth-map with FITS keys for XISF files
	
	- Include all camera properties, name, S/N, exposure, offset, gain, temperature, etc.
	
2. Implement 64 bit S/N by using double fetch and ud. (also in EFW)

3. Thoughts towards domain-specific language?

4. How to display camera properties in a window with VFX?  E.g.:

	- Direct output to a VT100 emulator, specifically running VFX Forth in Windows Terminal

5. Further benchtesting with cameras and testing with the ASI6200 at DSC
	