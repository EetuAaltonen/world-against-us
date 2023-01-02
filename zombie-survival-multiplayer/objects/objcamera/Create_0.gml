// Set camera
viewBaseSize = new Size(640, 360);
viewSize = viewBaseSize.Clone();
viewPosition = new Vector2(0, 0);

maxZoom = 2;
minZoom = 1;
baseZoom = 1;
zoom = baseZoom;

zoomInputStep = 0.5;
viewZoomStep = 0.05;

target = noone;
