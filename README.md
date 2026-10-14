# ForthASI
Forth language control of the ZWO ASI series of astroimaging cameras and accessories

Documentation at https://anding.github.io/ForthASI/

`subframe-at ( x y width height -- )` applies an enclosing sensor region for
in-memory analysis. It aligns X and width to eight pixels, aligns Y and height
to two pixels, and expands rather than clips the requested region.
`XORGSUBF` and `YORGSUBF` record the applied origin in FITS/XISF metadata.

`add-cameraFITS ( map -- )` consumes only the destination map, leaving caller
data unchanged. `ForthASI\ForthAstroCameraMaps_test2.f` checks this without
hardware, including standalone calls and ordered-map reset/reuse.
