\ test for ASI_SDK.f
\ requires XISF.f

: TAB
	9 emit
;

\ do-or-die error handler
: ASI.?abort ( n --)
	dup ASI.Error type CR
	IF abort THEN
;
	
\ check DLL and extern status
." ASICamera2.dll load address " ASICamera2.dll u. CR
.BadExterns CR

: connectCamera ( -- ior)
\ open an initialize a camera
	CameraID @ ASIOpenCamera ASI.?abort
	CameraID @ ASIInitCamera ASI.?abort
	
\ prepare an XISF image buffer
	XISFBuffer XISF.StartHeader
		XISF.StartXML
			XISF.StartImage
			XISF.FinishImage
		XISF.FinishXML
	XISF.FinishHeader	
;

: disconnectCamera ( -- ior)
\ close a camera
	CameraID @ ASICloseCamera ASI.?abort
;

: exposure ( uS -- ior)
\ set the exposure duration and initiate
	>R
	CameraID @ ASI_EXPOSURE R@ 0
	( CameraID ASI_EXPOSURE uS 0) ASISetControlValue ASI.?abort
	CameraID @ 0 ASIStartExposure ASI.?abort
	CR ."Exposing..." CR 
	R> 1000 * ms
;

: download ( c-addr u CameraID -- ior)
\ download an exposure into a camera buffer
	XISFBuffer XISF_DATA XISFDataMaxLen
	( CameraID addr n) ASIGetDataAfterExp ASI.?abort
	XISF.WriteFile
;

\ test
0 CameraID !
connectCamera
1000 ( us) expose
download
disconnectCamera


