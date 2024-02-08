if (instance_exists(ownerInstance))
{
	x = ownerInstance.x;
	y = ownerInstance.y;
	image_xscale = ownerInstance.image_xscale;
	image_yscale = ownerInstance.image_yscale;
	image_index = ownerInstance.image_index;
	image_angle = ownerInstance.image_angle;
	image_speed = ownerInstance.image_speed;
	depth = ownerInstance.depth - 1;

	if (initBoundingBox)
	{
		initBoundingBox = false;
		if (defaultMaskIndex != -1)
		{
			mask_index = (ownerInstance.mask_index == SPRITE_NO_MASK) ? SPRITE_NO_MASK : defaultMaskIndex;
		}
		boundingBox = new Vector2Rectangle(
			new Vector2(bbox_left, bbox_top), new Vector2(bbox_right, bbox_top),
			new Vector2(bbox_right, bbox_bottom), new Vector2(bbox_left, bbox_bottom)
		);
	} else {
		if (!is_undefined(boundingBox))
		{
			boundingBox.top_left_point.X = bbox_left;
			boundingBox.top_left_point.Y = bbox_top;
			
			boundingBox.top_right_point.X = bbox_right;
			boundingBox.top_right_point.Y = bbox_top;
			
			boundingBox.bottom_right_point.X = bbox_right;
			boundingBox.bottom_right_point.Y = bbox_bottom;
			
			boundingBox.bottom_left_point.X = bbox_left;
			boundingBox.bottom_left_point.Y = bbox_bottom;
		}
	}
}