// INITIALIZE HITBOX IF FOUND
if (initHitbox)
{
	InitializeHitbox(self);
	initHitbox = false;
}

var cameraViewPos = new Vector2(
	camera_get_view_x(view_camera[0]),
	camera_get_view_y(view_camera[0])
);
var cameraViewSize = new Size(
	camera_get_view_width(view_camera[0]),
	camera_get_view_height(view_camera[0])
);

var isTopLeftCornerInView = point_in_rectangle(x - abs(sprite_xoffset), y - abs(sprite_yoffset), cameraViewPos.X, cameraViewPos.Y, cameraViewPos.X + cameraViewSize.w, cameraViewPos.Y + cameraViewSize.h);
var isTopRightCornerInView = point_in_rectangle(x - abs(sprite_xoffset) + abs(sprite_width), y - abs(sprite_yoffset), cameraViewPos.X, cameraViewPos.Y, cameraViewPos.X + cameraViewSize.w, cameraViewPos.Y + cameraViewSize.h);
var isBottomRightCornerInView = point_in_rectangle(x - abs(sprite_xoffset) + abs(sprite_width), y - abs(sprite_yoffset) + abs(sprite_height), cameraViewPos.X, cameraViewPos.Y, cameraViewPos.X + cameraViewSize.w, cameraViewPos.Y + cameraViewSize.h);
var isBottomLeftCornerInView = point_in_rectangle(x - abs(sprite_xoffset), y - abs(sprite_yoffset) + abs(sprite_height), cameraViewPos.X, cameraViewPos.Y, cameraViewPos.X + cameraViewSize.w, cameraViewPos.Y + cameraViewSize.h);

isInCameraView = (isTopLeftCornerInView || isTopRightCornerInView || isBottomRightCornerInView || isBottomLeftCornerInView);

if (isInCameraView)
{
	var absSpriteSize = new Size(abs(sprite_width), abs(sprite_height));
	var spriteOffset = new Vector2(
		(absSpriteSize.w * 0.5) - abs(sprite_xoffset),
		absSpriteSize.h - abs(sprite_yoffset)
	);
	var bottomCenterPos = new Vector2(
		x + spriteOffset.X,
		y + spriteOffset.Y
	);
	var drawPriority = clamp(floor(bottomCenterPos.Y - cameraViewPos.Y), 0, cameraViewSize.h);
	
	depth = floor(cameraViewSize.h - drawPriority);
}

// TODO: Optimize this code
if (!is_undefined(global.HighlightHandlerRef))
{
	var highlightedInteractableLayer = layer_get_id(LAYER_HIGHLIGHT_INTERACTABLE);
	var highlightedTargetLayer = layer_get_id(LAYER_HIGHLIGHT_TARGET);
		
	if (self == global.HighlightHandlerRef.highlightedInteractable) layer_depth(highlightedInteractableLayer, depth);
	if (self == global.HighlightHandlerRef.highlightedTarget) layer_depth(highlightedTargetLayer, depth);
		
	if ((self != global.HighlightHandlerRef.highlightedInteractable && depth == layer_get_depth(highlightedInteractableLayer)) ||
		(self != global.HighlightHandlerRef.highlightedTarget && depth == layer_get_depth(highlightedTargetLayer))
	)
	{
		depth += 1;
	}
}