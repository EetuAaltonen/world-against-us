function SpriteDirection(_image_x_scale, _image_z_scale) constructor
{
	image_x_scale = _image_x_scale;
	image_z_scale = _image_z_scale;
	
	static Clone = function()
	{
		return new SpriteDirection(
			image_x_scale,
			image_z_scale
		);
	}
}