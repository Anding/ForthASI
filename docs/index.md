# ForthASI

https://github.com/Anding/ForthASI

This code facilitates interactive control of ZWO ASI cameras using the Forth programming language.  The code facilitates 'engineering level' control of the cameras  (e.g. you allocate your own memory for image download).  Other repositories facilitate, for example, saving images in XISF format and controlling a filterwheel and focuser.

In the spirit of Forth there is no ready-made application! Any interested users would write their own application-specific code to suit their needs.  My own application specific code is under development.

## Requirements

1. VFX Forth for Windows (32-bit version) at https://vfxforth.com/

2. ZWO's ASI SDK at https://www.zwoastro.com/software/.

	Copy ```AstroCamera2.dll``` (the 32-bit version) to the VFX Forth install directory, likely ```C:\MPE\VfxForth\Bin```

3. Required Forth language supporting libraries 

	https://github.com/Anding/ForthBase
	
	https://github.com/uho/forth-map

4. Optional and complementary Forth language libraries

	https://github.com/Anding/ForthXISF
	
	https://github.com/Anding/ForthEFW
	
	https://github.com/Anding/ForthEAF
	
	https://github.com/Anding/ForthKMTronic
	
	https://github.com/Anding/simple-tester



## Structure

```ForthASI\ForthASI``` contains the Forth language include files

```ASI_SDK.f``` provides Forth words that are basic wrappers for the C language functions in the ASI SDK.  These can be called interactively or within compiled code, but they are not necessarily the most convenient approach because Forth is not C.

```ASI_SDK_entend.f``` develops some Forth-like tools for handling the ASI SDK, but without imposing any abstraction layer or losing any granularity of control

```ForthAstroCamera.f``` builds on these tools to provide a user-friendly set of Forth words to interact with ASI cameras.  Again there is no imposed abstraction layer nor any loss of granulatity in control

```ForthAstroCameraMaps.f``` matches ASI camera properties to FITS keywords and provides a tool for assembling these in a key-value structure 

## Testcases

Regression testcases are made for all of the Forth language include files.  The testcases are  documentation-by-example of how the Forth language word should be used.  Looking through the testcases is the best way to see how the Forth language may be used to control interactively hardware devices such as astronomical cameras.

The testcases work with hardware and need to be locally reconfigured by users.




