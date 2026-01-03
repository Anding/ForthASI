\ Add FITS and XISF keywords to a map
NEED Windows

UUIDlength buffer: UUIDstring  
TSlength buffer: TSstring


\ the camera driver does not know - this must be set manually or by script
0 value image_type

: add-cameraFITS ( map --)
\ add key value pairs for FITS camara parameters
	>R
	s" T"                           R@ =>" SIMPLE"
	s" 16"                          R@ =>" BITPIX"	
	s" 1"							R@ =>" BSCALE"
	s" 32768"                       R@ =>" BZERO"       \ BITBIX=16 is a signed data type in the range -32768 to 32737
	s" 2"                           R@ =>" NAXIS"	
	camera_ROI ( width height bin)
	rot (.)                         R@ =>" NAXIS1"
	swap (.)                        R@ =>" NAXIS2"
	(.) 2dup                        R@ =>" XBINNING"
                                    R@ =>" YBINNING"	
	camera_offset -1 * (.)          R@ =>" PEDESTAL"		
	exposure_time                   R@ =>" EXPTIME"     \ in seconds with decimal places if less that 1 sec
	camera_exposure (.)             R@ =>" EXPOINUS"    \ in micro seconds	
	camera_exposure 1000 / (.)      R@ =>" EXPOINMS"    \ in milli seconds	
	s"  "                           R@ =>" #CAMERA"		\ a header to indicate the source of these FITS values		
	effective_pixel_size	2dup    R@ =>" XPIXSZ"
	                                R@ =>" YPIXSZ"																																	
	camera_name                     R@ =>" INSTRUME"
 	camera_SN                       R@ =>" INSTRSN"	
 	electrons_per_adu               R@ =>" EGAIN"	
	camera_temperature (.)          R@ =>" CCD-TEMP"		
	target_temperature (.)          R@ =>" SET-TEMP"	
 	camera_cooler (.OnOff)          R@ =>" COOLER"
 	cooler_power (.)                R@ =>" COOLPWR" 	
 	camera_fan (.OnOff)             R@ =>" FAN"
 	camera_dew_heater (.OnOff)      R@ =>" DEWHEAT"
 	camera_bandwidth	(.)         R@ =>" USBLIMIT"    \ bandwidth
 	camera_gain (.)                 R@ =>" GAIN"
	R> drop
;	

: add-cameraXISF ( map --)
\ add key value pairs for XISF camera parameters
	>R
    s" UInt16"                      R@ =>" sampleFormat"    \ not used in writing the header
    s" Gray"                        R@ =>" colorSpace"      \   which hardcodes these keys
	camera_offset (.)               R@ =>" OFFSET"
	R> drop
;
	

