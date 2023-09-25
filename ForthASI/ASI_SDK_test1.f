\ test for ASI_SDK.f

include "%idir%\..\..\ForthBase\ForthBase.f"
include "%idir%\ASI_SDK.f"
	
\ check DLL and extern status
." ASICamera2.dll load address " ASICamera2.dll u. CR
.BadExterns CR

\ get and print all the properties of all the connected cameras
: ASI.ReviewCameras
	ASIGetNumOfConnectedCameras ( -- n)
	?dup
	IF
		\ loop over each connected camera
		0 do
			." Camera index " i . CR
			ASICameraInfo i ASIGetCameraProperty ( buffer index --) ASI.?abort
			ASICameraInfo ASI_CAMERA_NAME TAB ." ASI_CAMERA_NAME " zcount type CR
			ASICameraInfo ASI_CAMERA_ID TAB ." ASI_CAMERA_ID " l@ dup u. CR
				CameraID !
			ASICameraInfo ASI_MAX_HEIGHT TAB ." ASI_MAX_HEIGHT "  l@ . CR
			ASICameraInfo ASI_MAX_WIDTH TAB ." ASI_MAX_WIDTH "  l@ . CR
			ASICameraInfo ASI_IS_COLOR_CAM TAB ." ASI_IS_COLOR_CAM "  l@ . CR
			ASICameraInfo ASI_BAYER_PATTERN TAB ." ASI_BAYER_PATTERN "  l@ . CR
			ASICameraInfo ASI_SUPPORTED_BINS TAB ." ASI_SUPPORTED_BINS " CR 
			dup 64 + swap do 
				 TAB TAB ." bin "	I l@ . CR
			4 +loop
			ASICameraInfo ASI_MECHANICAL_SHUTTER TAB ." ASI_MECHANICAL_SHUTTER " l@ . CR
			ASICameraInfo ASI_ST4_PORT TAB ." ASI_ST4_PORT " l@ . CR
			ASICameraInfo ASI_IS_COOLER_CAM TAB ." ASI_IS_COOLER_CAM " l@ . CR
			ASICameraInfo ASI_IS_USB3_HOST TAB ." ASI_IS_USB3_HOST " l@ . CR
			ASICameraInfo ASI_IS_USB3_CAMERA TAB ." ASI_IS_USB3_CAMERA " l@ . CR
			ASICameraInfo ASI_BIT_DEPTH TAB ." ASI_BIT_DEPTH " l@ . CR
			ASICameraInfo ASI_IS_TRIGGER_CAM TAB ." ASI_IS_TRIGGER_CAM " l@ . CR
			CR
			
			\ open the camera and check the number of controls
			CameraID @ ASIOpenCamera ASI.?abort
			CameraID @ ASINumberOfControls ASIGetNumOfControls ASI.?abort
			TAB ." Number of controls " ASINumberOfControls @ . CR
			
			\ loop over each control and list the control properties and settings
			ASINumberOfControls @ 0 do
				." Control index " i . CR
				CameraID @ I ASIControlCaps ASIGetControlCaps ASI.?abort
				ASIControlCaps ASI_CONTROL_NAME TAB ." ASI_CONTROL_NAME " zcount type CR
				ASIControlCaps ASI_CONTROL_DESCRIPTION TAB ." ASI_CONTROL_DESCRIPTION " zcount type CR
				ASIControlCaps ASI_MAX_VALUE TAB ." ASI_MAX_VALUE " l@s . CR			\ note sign extension
				ASIControlCaps ASI_MIN_VALUE TAB ." ASI_MIN_VALUE " l@s . CR
				ASIControlCaps ASI_DEFAULT_VALUE TAB ." ASI_DEFAULT_VALUE " l@s . CR
				ASIControlCaps ASI_IS_AUTO_SUPPORTED TAB ." ASI_IS_AUTO_SUPPORTED " l@ . CR
				ASIControlCaps ASI_IS_WRITABLE TAB ." ASI_IS_WRITABLE " l@ . CR	
				ASIControlCaps ASI_CONTROL_TYPE TAB ." ASI_CONTROL_TYPE " l@ dup . CR	
				\ list the control setting
					CameraID @ swap ControlValue ControlAuto ( CameraID ASI_CONTROL_TYPE &ControlValue &ControlAuto)
				ASIGetControlValue TAB ASI.?abort
					TAB TAB ." Control Value " ControlValue l@ . CR
					TAB TAB ." Control Auto " ControlAuto l@ . CR
				CR
			loop
			
			\ get the image region and binning
			." ROI Format" CR
			CameraID @ ROIWidth ROIHeight ROIBin ASIImgType ( CameraID &Width &Height &Bin &ImageType) 
			ASIGetROIFormat  ASI.?ABORT
			TAB ." Width " ROIWidth l@ . CR
			TAB ." Height " ROIHeight l@ . CR
			TAB ." Bin " ROIBin l@ . CR
			TAB ." ASIImgType " ASIImgType l@ . CR
			CR 
			
			\ get the Flash ID
			\ CameraID @ ASIID ASIGetID ASI.?ABORT
			\ ." Flash ID " ASIID zcount type CR
			
			\ get the serial number
			." Serial Number " CR
			CameraID @ ASISN ASIGetSerialNumber ASI.?ABORT
			TAB ASISN @ u. CR
			
			\ close the camera
			CameraID @ ASICloseCamera ASI.?abort
			CR CR
		loop
	ELSE
		." No ASI cameras connected" CR
	THEN
;

CR
ASI.ReviewCameras


