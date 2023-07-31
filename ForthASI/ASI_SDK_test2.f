\ test for ASI_SDK.f
\ requires XISF.f

XISF_BUFFER BUFFER XISFBuffer

: TAB
	9 emit
;

\ do-or-die error handler
: ASI.?abort ( n --)
	dup ASI.Error type CR
	IF abort THEN
	flushKeys
;
	
\ check DLL and extern status
CR
." ASICamera2.dll load address " ASICamera2.dll u. CR
.BadExterns CR

: connectCamera ( -- )
\ open an initialize a camera
	CameraID @ ASIOpenCamera ASI.?abort
	CameraID @ ASIInitCamera ASI.?abort
	CameraID @ 3096 2080 1 ASI_IMG_RAW16 ASISetROIFormat ASI.?abort
;

: prepareBuffer ( --)
\ prepare an XISF image buffer
	3096 ImageWidth !
	2080 ImageHeight !
	XISFBuffer XISF.StartHeader
		XISF.StartXML
			XISF.StartImage
			XISF.FinishImage
		XISF.FinishXML
	XISF.FinishHeader	
;

: disconnectCamera ( -- )
\ close a camera
	CameraID @ ASICloseCamera ASI.?abort
;

: expose ( uS -- )
\ set the exposure duration and initiate
	>R
	CameraID @ ASI_EXPOSURE R@ 0
	( CameraID ASI_EXPOSURE uS 0) ASISetControlValue ASI.?abort
	CameraID @ 0 ASIStartExposure ASI.?abort
	CR ." Exposing..." CR 
	R> 1000 / 200 + ms										\ allow a 200ms delay after the exposure for the SDK
;

: download ( c-addr u -- )
\ download an exposure into a camera buffer and save it to a file
	CameraID @ XISFBuffer XISF_DATA XISFDataMaxLen
	( CameraID addr n) ASIGetDataAfterExp ASI.?abort
	( c-addr u) XISF.WriteFile
;

\ test
CR
ASIGetNumOfConnectedCameras . ."  connected cameras"  \ always call this first to initialize the SDK
0 CameraID !

CR
connectCamera
prepareBuffer
1000 ( us) expose
s" C:\test\ASI_SDK_test2.XISF" download
disconnectCamera


