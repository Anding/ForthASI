# ForthASI
Forth language control of the ZWO ASI series of astroimaging cameras and accessories

Documentation at https://anding.github.io/ForthASI/

`subframe-at ( x y width height -- )` applies an exact sensor region for
in-memory analysis. It rounds width up to the ASI multiple-of-eight rule,
rounds height up to an even value, and shifts the origin only when needed to
remain on the sensor. `XORGSUBF` and `YORGSUBF` record the applied origin in
FITS/XISF metadata.
