function CharacterActionCooldown(_actionIndex, _cooldownDuration) constructor
{
	action_index = _actionIndex;
	cooldown_timer = new Timer(_cooldownDuration);
	cooldown_timer.StartTimer();
	
	
	static OnDestroy = function(_struct = self)
	{
		ReleaseVariableFromMemory(_struct.cooldown_timer);
		_struct.cooldown_timer = undefined;
	}
	
	static Update = function()
	{
		cooldown_timer.Update();
	}
}