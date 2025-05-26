function GetRandomPointInCircle(_vectorRef, _radius)
{
	var r = _radius * sqrt(random(1));
	var theta = random(1) * 2 * pi;
	var xPos = 0 /*centerX*/ + r * cos(theta);
	var yPos = 0 /*centerY*/ + r * sin(theta); 
	
	_vectorRef.X = xPos;
	_vectorRef.Y = yPos;
}