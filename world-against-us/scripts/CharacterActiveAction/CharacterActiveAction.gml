function CharacterActiveAction(_instanceRef, _actionIndex, _actionAnimation, _actionDuration, _actionCooldown, _interruptMovement, _isInterruptible) constructor
{
	instance_ref = _instanceRef;
	action_index = _actionIndex;
	action_animation = _actionAnimation; // SET IF ACTION IS ANIMATION RELATED
	action_duration = _actionDuration; // SET IF ACTION IS DURATION RELATED
	action_cooldown = _actionCooldown;
	interrupt_movement = _interruptMovement;
	is_interruptible = _isInterruptible;
	
	static OnDestroy = function(_struct = self)
	{
		// NO GARBAGE CLEANING
	}
}