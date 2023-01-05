var cameraViewPos = new Vector2(
	camera_get_view_x(view_camera[0]),
	camera_get_view_y(view_camera[0])
);
var cameraViewSize = new Size(
	camera_get_view_width(view_camera[0]),
	camera_get_view_height(view_camera[0])
);
var instancePriority = ds_priority_create();
with (objInstanceParent)
{
	if (point_in_rectangle(x, y,
		cameraViewPos.X - cameraViewSize.w,
		cameraViewPos.Y - cameraViewSize.h,
		cameraViewPos.X + (cameraViewSize.h * 2),
		cameraViewPos.Y + (cameraViewSize.h * 2)
	))
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
		ds_priority_add(instancePriority, self, -drawPriority);
	}
	
	// ALWAYS PERFORM DRAW BEGING EVENT
	event_perform(ev_draw, ev_draw_begin);
}

var instanceCount = ds_priority_size(instancePriority);
for (var i = 0; i < instanceCount; i++)
{
	var instance = ds_priority_delete_max(instancePriority);
	if (instance_exists(instance))
	{
		with (instance)
		{
			if (visible) { event_perform(ev_draw, ev_draw_normal); }
		}
	}
}