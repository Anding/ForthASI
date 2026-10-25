# ForthASI
Forth language control of the ZWO ASI series of astroimaging cameras and accessories

Documentation at https://anding.github.io/ForthASI/

`subframe-at ( x y width height -- )` applies an enclosing sensor region for
in-memory analysis. It aligns X and width to eight pixels, aligns Y and height
to two pixels, and expands rather than clips the requested region.
`XORGSUBF` and `YORGSUBF` record the applied origin in FITS/XISF metadata.

`add-cameraFITS ( map -- )` consumes only the destination map, leaving caller
data unchanged. `ForthASI\ForthAstroCameraMaps_test2.f` checks this without
hardware, including standalone calls, retained-key reset, and erase/reuse.

Ordinary SDK errors report and return normally; `ASI.?abort` retains its name
but does not abort. Failed scalar reads return initialized zero values; a
failed exposure-status query returns `ASI_EXP_FAILED`. Failed attachment and
ROI changes skip dependent operations. Exposure start uses the SDK result
directly: a busy camera reports an error rather than waiting or retrying.
A later iteration can try again.
`(start-exposure) ( -- started? )` and
`(download-image) ( addr u -- downloaded? )` report errors and return success
flags for acquisition control flow. The interactive `start-exposure` and
`download-image` words keep their existing stack effects.
`ForthASI\ForthAstroCamera_test0.f` tests failed reads with SDK mocks and
no hardware.
