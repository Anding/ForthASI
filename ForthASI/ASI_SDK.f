\ Forth words directly corresponding to the ASI SDK
\ requires ForthBase.f


LIBRARY: ASICamera2.dll

Extern: int "C" ASICloseCamera( int CameraID ) ;
Extern: int "C" ASIDisableDarkSubtract( int CameraID ) ;
Extern: int "C" ASIGetCameraProperty( int * ASICameraInfo , int CameraIndex ) ;
Extern: int "C" ASIGetCameraPropertyByID( int CameraID , int * ASICameraInfo ) ;
Extern: int "C" ASIGetControlCaps( int CameraID , int ControlIndex , int * ASI_CONTROL_CAPS) ;
Extern: int "C" ASIGetControlValue( int CameraID , int ASI_CONTROL_TYPE, int * ControlValue , int * ControlAuto ) ;
Extern: int "C" ASIGetDataAfterExp( int CameraID, unsigned char * ImageBuffer, int ImageBufferSize ) ;
Extern: int "C" ASIGetExpStatus( int CameraID , int * ASI_EXPOSURE_STATUS ) ;
Extern: "C" ASIGetGainOffset( ) ;
Extern: int "C" ASIGetID( intCameraID , int * ASI_ID ) ;
Extern: int "C" ASIGetNumOfConnectedCameras( void ) ;
Extern: int "C" ASIGetNumOfControls( int CameraID , int * ASINumberOfControls) ;
Extern: int "C" ASIGetROIFormat( int CameraID , int * Width , int * Height , int * Bin , int * ASI_IMG_TYPE ) ;
Extern: char * "C" ASIGetSDKVersion( ) ;
Extern: int "C" ASIGetSerialNumber( int CameraID , int * ASI_SN) ;
Extern: int "C" ASIGetStartPos( int CameraID , int * StartX, * StartY) ;
Extern: int "C" ASIInitCamera( int CameraID ) ;
Extern: int "C" ASIOpenCamera( int CameraID ) ;
Extern: int "C" ASIPulseGuideOff( int CameraID , int ASI_GUIDE_DIRECTION ) ;
Extern: int "C" ASIPulseGuideOn( int CameraID , int ASI_GUIDE_DIRECTION ) ;
Extern: int "C" ASISetCameraMode( int CameraID, int ASI_CAMERA_MODE ) ;
Extern: int "C" ASISetControlValue( int CameraID , int ASI_CONTROL_TYPE , int ControlValue , int ControlAuto ) ;
Extern: int "C" ASISetID( int CameraID, int * ASI_ID ) ;
Extern: int "C" ASISetROIFormat( int CameraID , int Width , int Height , int Bin, int ASI_IMG_TYPE ) ;
Extern: int "C" ASISetStartPos( int CameraID , int StartX , int StartY ) ;
Extern: int "C" ASIStartExposure( int CameraID, int IsDark ) ;
Extern: int "C" ASIStopExposure( int CameraID ) ;

: ASI.Error ( n -- caddr u)
\ return the ASI text error message
	CASE
	 0 OF s" SUCCESS" ENDOF
	 1 OF s" INVALID_INDEX" ENDOF
	 2 OF s" INVALID_ID" ENDOF
	 3 OF s" INVALID_CONTROL_TYPE" ENDOF
	 4 OF s" CAMERA_CLOSED" ENDOF	
	 5 OF s" CAMERA_REMOVED" ENDOF	
	 6 OF s" INVALID_PATH" ENDOF
	 7 OF s" INVALID_FILEFORMAT" ENDOF
	 8 OF s" INVALID_SIZE" ENDOF
	 9 OF s" INVALID_IMGTYPE" ENDOF
	10 OF s" OUTOF_BOUNDARY" ENDOF
	11 OF s" TIMEOUT" ENDOF
	12 OF s" INVALID_SEQUENCE" ENDOF
	13 OF s" BUFFER_TOO_SMALL" ENDOF
	14 OF s" VIDEO_MODE_ACTIVE" ENDOF
	15 OF s" EXPOSURE_IN_PROGRESS" ENDOF
	16 OF s" GENERAL_ERROR" ENDOF
	17 OF s" INVALID_MODE" ENDOF
	s" OTHER_ERROR" rot 							( caddr u n)  \ ENDCASE consumes the case selector
	ENDCASE 
;

BEGIN-STRUCTURE ASI_CAMERA_INFO 		\ 240 bytes including padding
64 +FIELD ASI_CAMERA_NAME
 4 +FIELD ASI_CAMERA_ID
 4 +FIELD ASI_MAX_HEIGHT
 4 +FIELD ASI_MAX_WIDTH
 4 +FIELD ASI_IS_COLOR_CAM
 4 +FIELD ASI_BAYER_PATTERN
64 +FIELD ASI_SUPPORTED_BINS
32 +FIELD ASI_SUPPORTED_VIDEO_FORMAT
12 +FIELD ASI_PIXEL_SIZE				\ long double
 4 +FIELD ASI_MECHANICAL_SHUTTER
 4 +FIELD ASI_ST4_PORT
 4 +FIELD ASI_IS_COOLER_CAM
 4 +FIELD ASI_IS_USB3_HOST
 4 +FIELD ASI_IS_USB3_CAMERA
 4 +FIELD ASI_ELEC_PER_ADU				\ float
 4 +FIELD ASI_BIT_DEPTH
 4 +FIELD ASI_IS_TRIGGER_CAM
16 +FIELD ASI_CAMERA_INFO_UNUSED
END-STRUCTURE

BEGIN-STRUCTURE ASI_CONTROL_CAPS		\ 248 bytes
 64 +FIELD ASI_CONTROL_NAME
128 +FIELD ASI_CONTROL_DESCRIPTION
  4 +FIELD ASI_MAX_VALUE
  4 +FIELD ASI_MIN_VALUE
  4 +FIELD ASI_DEFAULT_VALUE
  4 +FIELD ASI_IS_AUTO_SUPPORTED
  4 +FIELD ASI_IS_WRITABLE
  4 +FIELD ASI_CONTROL_TYPE
 32 +FIELD ASI_CONTROL_CAPS_UNUSED
END-STRUCTURE

BEGIN-STRUCTURE ASI_ID				\ 8 bytes
  8 +FIELD ASI_ID_ID
END-STRUCTURE

BEGIN-ENUM ( ASI_CONTROL_TYPE)
	+ENUM ASI_GAIN
	+ENUM ASI_EXPOSURE
	+ENUM ASI_GAMMA
	+ENUM ASI_WB_R
	+ENUM ASI_WB_B
	+ENUM ASI_OFFSET
	+ENUM ASI_BANDWIDTHOVERLOAD
	+ENUM ASI_OVERCLOCK
	+ENUM ASI_TEMPERATURE
	+ENUM ASI_FLIP
	+ENUM ASI_AUTO_MAX_GAIN
	+ENUM ASI_AUTO_MAX_EXP
	+ENUM ASI_AUTO_TARGET_BRIGHTNESS
	+ENUM ASI_HARDWARE_BIN
	+ENUM ASI_HIGH_SPEED_MODE
	+ENUM ASI_COOLER_POWER_PERC
	+ENUM ASI_TARGET_TEMP
	+ENUM ASI_COOLER_ON
	+ENUM ASI_MONO_BIN
	+ENUM ASI_FAN_ON
	+ENUM ASI_PATTERN_ADJUST
	+ENUM ASI_ANTI_DEW_HEATER
	+ENUM ASI_FAN_ADJUST,
	+ENUM ASI_PWRLED_BRIGNT,
	+ENUM ASI_USBHUB_RESET,
	+ENUM ASI_GPS_SUPPORT,
	+ENUM ASI_GPS_START_LINE,
	+ENUM ASI_GPS_END_LINE,
	+ENUM ASI_ROLLING_INTERVAL
END-ENUM

BEGIN-ENUM ( ASI_IMG_TYPE )
	+ENUM ASI_IMG_RAW8
	+ENUM ASI_IMG_RGB24
	+ENUM ASI_IMG_RAW16
	+ENUM ASI_IMG_Y8
END-ENUM	
-1 CONSTANT	ASI_IMG_END

BEGIN-ENUM ( ASI_GUIDE_DIRECTION )
	+ENUM ASI_GUIDE_NORTH
	+ENUM ASI_GUIDE_SOUTH
	+ENUM ASI_GUIDE_EAST
	+ENUM ASI_GUIDE_WEST
END-ENUM

BEGIN-ENUM ( ASI_EXPOSURE_STATUS )
	+ENUM ASI_EXP_IDLE 		\ idle states, you can start exposure now
	+ENUM ASI_EXP_WORKING	\ exposing
	+ENUM ASI_EXP_SUCCESS	\ exposure finished and waiting for download
	+ENUM ASI_EXP_FAILED		\ exposure failed, you need to start exposure again
END-ENUM

BEGIN-ENUM ( ASI_CAMERA_MODE )
	+ENUM ASI_MODE_NORMAL
END-ENUM

\ pass by reference to ASI library functions
ASI_CAMERA_INFO	BUFFER: ASICameraInfo
ASI_CONTROL_CAPS	BUFFER: ASIControlCaps
ASI_ID				BUFFER: ASIID
ASI_ID				BUFFER: ASISN

\ do-or-die error handler
: ASI.?abort ( n --)
	flushKeys	
	dup 
	IF 
		ASI.Error type CR
		abort 
	ELSE
		drop	
	THEN
;

