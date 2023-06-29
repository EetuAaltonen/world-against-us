traceTailPosition.X += traceTailStep.X;
traceTailPosition.Y += traceTailStep.Y;

if (isHit && ((abs(x - traceTailPosition.X ) <= abs(traceTailStep.X)) && (abs(y - traceTailPosition.Y) <= abs(traceTailStep.Y))))
{
	instance_destroy();
}