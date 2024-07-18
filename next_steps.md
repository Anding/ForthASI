ForthASI next steps
===================

1. Review the control capabilities of the ASI2600, ASI6200 and create Forth words for all relevant controls
2. What is HighSpeedMode: video, DDR, something else?
3. ```ForthAstroCameraFITS.f``` to populate a forth-map with FITS keys for XISF files
	
	- Include all camera properties, name, S/N, exposure, offset, gain, temperature, etc.
	
4. Implement 64 bit S/N by using double fetch and ud. (also in EFW)
5. Thoughts towards domain-specific language?
6. How to display camera properties in a window with VFX?  E.g.:

	- Direct output to a VT100 emulator
	- TKL windows
	- .HTML/.MD page, dynamically updated viewed in the browser
7. Further benchtesting with cameras and testing with the ASI6200 at DSC
	