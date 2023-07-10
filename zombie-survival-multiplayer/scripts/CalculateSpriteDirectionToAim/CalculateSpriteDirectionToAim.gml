function CalculateSpriteDirectionToAim(_position, _aimPosition)
{
	var spriteDirection = new SpriteDirection(1, 1);
	spriteDirection.image_x_scale = (_aimPosition.X >= _position.X) ? 1 : -1;
	spriteDirection.image_z_scale = (image_angle > 15 && image_angle < 165) ? -1 : 1;
	
	return spriteDirection;
}