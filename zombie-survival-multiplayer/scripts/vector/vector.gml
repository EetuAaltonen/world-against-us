function RotateVector(_baseVector, _angle)
{
	var radAngle = degtorad(-_angle);
	var cs = cos(radAngle);
	var sn = sin(radAngle);
	var newX = _baseVector.X * cs - _baseVector.Y * sn;
	var newY = _baseVector.X * sn + _baseVector.Y * cs;
	
	return new Vector2(newX, newY);
}