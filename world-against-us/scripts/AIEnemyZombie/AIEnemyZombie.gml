function AIEnemyZombie(_instanceRef, _aiStates, _defaultAIStateIndex, _character, _colliderRef, _targetSeekInterval, _pathUpdateInterval, _pathBlockingRadius) : AIEnemyHuman(_instanceRef, _aiStates, _defaultAIStateIndex, _character, _colliderRef, _targetSeekInterval, _pathUpdateInterval, _pathBlockingRadius) constructor
{
	wander_origin_pos = new Vector2(_instanceRef.x, _instanceRef.y);
	wander_radius = MetersToPixels(10);
	
	min_idle_state_duration = 6000;
	max_idle_state_duration = 12000;
	
	// SET RANDOM IDLE TIMER
	state_machine.state_timer.setting_time = irandom_range(min_idle_state_duration, max_idle_state_duration);
	state_machine.state_timer.StartTimer();
	

	static OnDestroy = function(_struct = self)
	{
		// NO GARBAGE CLEANING
	}
	
	static Update = function()
	{
		if (!is_undefined(collider_ref))
		{
			if (!is_undefined(collider_ref.collision_body))
			{
				if (collider_ref.collision_body.state == COLLISION_BODY_STATE.ON_DEAD)
				{
					OnDead();
				}
			}
		}
		return state_machine.Update(self);
	}
	
	static OnDead = function()
	{
		state_machine.SetState(AI_STATE_ZOMBIE.ON_DEAD);
	}
	
	static SeekTargetInVision = function(_objectIndex)
	{
		var targetInstance = noone;
		if (instance_exists(instance_ref))
		{
			var visionRadius = (!is_undefined(character)) ? character.vision_radius : 0;
			targetInstance = GetNearestTargetInstanceInRadius(_objectIndex, visionRadius);
		}
		return targetInstance;
	}
	
	static StartChasingTarget = function()
	{
		var isChaseStarted = false;
		return isChaseStarted;
	}
}