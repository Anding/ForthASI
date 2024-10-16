\ Add FITS and XISF keywords to a map
\ 	ASI version

\ requires forthbase.f
\ requires ASI_SDK.f
\ requires ASI_SDK_extend.f
\ requires maps.fs
\ requires map-tools.fs
\ requires forthbase/windows.f

\ FITS keywords supported by MaxImDL
\ ==================================
\ SIMPLE – always ”T”, indicating a FITS header.
\ BITPIX – indicates array format. Options include unsigned 8-bit (8), signed 16 bit (16), signed 32 bit (32), 32-bit IEEE float (-32), and 64-bit IEEE float (-64)
\ NAXIS – number of axes in the data array. MaxIm DL uses 2 for monochrome images, and 3 for color images
\ NAXIS1 – corresponds to the X axis
\ NAXIS2 – corresponds to the Y axis
\ NAXIS3 – present only for color images; value is always 3 (red, green, blue color planes are present in that order)
\ BSCALE – this value should be multiplied by the data array values when reading the FITS file
\ BZERO – this value should be added to the data array values when reading the FITS file
\ INSTRUME - detector instrument name
\ CCD-TEMP – actual measured sensor temperature at the start of exposure in degrees C
\ EXPTIME – duration of exposure in seconds
\ EGAIN – electronic gain in photoelectrons per ADU.
\ IMAGETYP – type of image: Light Frame, Bias Frame, Dark Frame, Flat Frame, or Tricolor Image
\ PEDESTAL – correction to add for zero-based ADU
\ SET-TEMP – CCD temperature setpoint in degrees C
\ XBINNING – binning factor used on X axis
\ XPIXSZ – physical X dimension of the sensor's pixels in microns. Includes binning.
\ YBINNING – binning factor used on Y axis
\ YPIXSZ – physical Y dimension of the sensor's pixels in microns. Includes binning.
\ DATEOBS - UTC exposure time of the start of the image

\ FITS keywords defined here for the ASI camera
\ =============================================
\ INSTRSN 	- detector serial number
\ COOLER		- cooler on or off
\ FAN			- fan on or off
\ DEWHEAT	- dew heater on or off
\ COOLPWR	- cooler power percentage
\ BANDWIDT	- USB bandwidth
\ UUID		- generated UUID

UUIDlength buffer: UUIDstring  
TSlength buffer: TSstring


\ the camera driver does not know - this must be set manually or by script
0 value image_type

: add-cameraFITS ( map --)
\ add key value pairs for FITS camara parameters
	>R
	s"  " 							R@ =>" #CAMERA"		\ a header to indicate the source of these FITS values	
	s" T"								R@ =>" SIMPLE"
	s" 16"							R@ =>" BITPIX"
	s" 1.0"							R@ =>" BSCALE"
	s" 0.0"							R@ =>" BZERO"		
	s" 2"								R@ =>" NAXIS"
	exposure_time					R@ =>" EXPTIME" 	
	camera_ROI ( width height bin)
	rot (.)							R@ =>" NAXIS1"
	swap (.) 						R@ =>" NAXIS2"
	(.) 2dup 						R@ =>" XBINNING"
										R@ =>" YBINNING"
	effective_pixel_size	2dup	R@ =>" XPIXSZ"
										R@ =>" YPIXSZ"	
	camera_offset -1 * (.)		R@ =>" PEDESTAL"																																		
	camera_name						R@ =>" INSTRUME"
 	camera_SN 						R@ =>" INSTRSN"	
 	electrons_per_adu				R@ =>" EGAIN"	
	camera_temperature (.)		R@ =>" CCD-TEMP"		
	target_temperature (.)		R@ =>" SET-TEMP"	
 	camera_cooler (.OnOff)		R@ =>" COOLER"
 	cooler_power (.)				R@ =>" COOLPWR" 	
 	camera_fan (.OnOff)			R@ =>" FAN"
 	camera_dew_heater (.OnOff)	R@ =>" DEWHEAT"
 	camera_bandwidth	(.)		R@ =>" BANDWIDT"
	R> drop
;	

: add-cameraXISF ( map --)
\ add key value pairs for XISF camera parameters
	>R
	s" UInt16" 						R@ =>" sampleFormat"
	s" Gray" 						R@ =>" colorSpace"
	camera_offset (.)				R@ =>" OFFSET"
	R> drop
;
	

