function AIStateZombieWander(_aiBase)
{
	var isWandering = true;
	if (is_undefined(_aiBase.target_position))
	{
		// CALCULATE POS WITHIN ROOM BOUNDARIES
		var roomEdgeMargin = MetersToPixels(0.1);
		var newTargetPos = new Vector2(_aiBase.wander_origin_pos.X, _aiBase.wander_origin_pos.Y);
		var posInCircle = new Vector2(0, 0);
		var isInRoomBoundaries = false;
		while (!isInRoomBoundaries)
		{
			GetRandomPointInCircle(posInCircle, _aiBase.wander_radius);
			posInCircle.X += _aiBase.wander_origin_pos.X;
			posInCircle.Y += _aiBase.wander_origin_pos.Y;
			
			// GET IF POINT IS WITHIN ROOM BOUNDARIES
			isInRoomBoundaries = (
				(posInCircle.X > roomEdgeMargin && posInCircle.Y > roomEdgeMargin) &&
				(posInCircle.X < (room_width - roomEdgeMargin) && posInCircle.Y < (room_height - roomEdgeMargin))
			);
		}
		
		// SET TARGET POSITION
		newTargetPos.X = posInCircle.X;
		newTargetPos.Y = posInCircle.Y;
		_aiBase.SetTargetPosition(newTargetPos);
		isWandering = _aiBase.StartPathingToPoint();
	} else {
		var pathPointCount = path_get_number(_aiBase.path_to_target.path);
		if (!path_exists(_aiBase.path_to_target.path) ||
			_aiBase.instance_ref.path_position >= 1 ||
			pathPointCount <= 0)
		{
			_aiBase.EndPathing();
			_aiBase.state_machine.SetState(AI_STATE_ZOMBIE.IDLE);
		
			// SET RANDOM IDLE TIMER
			_aiBase.state_machine.state_timer.setting_time = irandom_range(_aiBase.min_idle_state_duration, _aiBase.max_idle_state_duration);
			_aiBase.state_machine.state_timer.StartTimer();
		}
	}
	return isWandering;
}