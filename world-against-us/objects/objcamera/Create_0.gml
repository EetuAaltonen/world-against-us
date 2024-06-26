// CAMERA PROPERTIES
viewBaseSize = new Size(VIEW_BASE_WIDTH, VIEW_BASE_HEIGHT);
viewSize = viewBaseSize.Clone();
viewPosition = new Vector2(0, 0);

// ZOOM PROPERTIES
baseMaxZoom = 4;
maxZoom = baseMaxZoom;
baseMinZoom = 1;
minZoom = baseMinZoom;
baseZoom = 1;
zoom = baseZoom;

zoomInputStep = 0.5;
viewZoomStep = 0.05;

// CAMERA TARGET
cameraTarget = noone;