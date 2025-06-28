function CharacterHumanActionHandler() constructor
{
	active_action = undefined;
	is_movement_interrupted = false;
	action_duration_timer = new Timer(0);
	action_cooldowns = undefined;
	is_initialized = false;
	
	Initialize();
	
	static OnDestroy = function(_struct = self)
	{
		ReleaseVariableFromMemory(_struct.action_duration_timer);
		_struct.action_duration_timer = undefined;
		ReleaseVariableFromMemory(_struct.action_cooldowns);
		_struct.action_cooldowns = undefined;
		
	}
	
	static Initialize = function()
	{
		if (!is_initialized)
		{
			// INIT ARRAY WITH LENGHT OF CHARACTER ACTION ENUM
			action_cooldowns[CHARACTER_ACTION.ENUM_LENGTH] = undefined;
			// POPULATE ACTION COOLDOWN ARRAY
			var actionCooldownCount = array_length(action_cooldowns);
			for (var i = 0; i < actionCooldownCount; i++)
			{
				// SET DEFAULT VALUE TO UNDEFINED
				action_cooldowns[i] = undefined;
			}
			is_initialized = true;
		}
	}
	
	static Update = function()
	{
		// UPDATE ACTION DURATION TIMER
		action_duration_timer.Update();
		if (action_duration_timer.IsTimerStopped())
		{
			ResetAction();
		}
		
		// UPDATE ACTION COOLDOWNS
		var actionCooldownCount = array_length(action_cooldowns);
		for (var i = 0; i < actionCooldownCount; i++)
		{
			var actionCooldown = action_cooldowns[@ i];
			if (!is_undefined(actionCooldown))
			{
				actionCooldown.Update();
				if (actionCooldown.cooldown_timer.IsTimerStopped())
				{
					// REMOVE STOPPED COOLDOWNS
					action_cooldowns[@ i] = undefined;
					ReleaseVariableFromMemory(actionCooldown);
				}
			}
		}
	}
	
	static SetAction = function(_actionIndex, _interruptMovement, _actionDuration, _actionCooldownDuration, _overrideActiveAction)
	{
		if (is_undefined(active_action) || _overrideActiveAction)
		{
			active_action = _actionIndex;
			is_movement_interrupted = _interruptMovement;
			
			// SET ACTION ACTIVE IF IT HAS DURATION
			if (!is_undefined(_actionDuration))
			{
				action_duration_timer.setting_time = _actionDuration;
				action_duration_timer.StartTimer();
			}
			// SET ACTION TO COOLDOWN
			SetActionCooldown(_actionIndex, _actionCooldownDuration);
		}
	}
	
	static SetActionCooldown = function(_actionIndex, _actionCooldownDuration)
	{
		if (!is_undefined(_actionCooldownDuration))
		{
			action_cooldowns[_actionIndex] = new CharacterActionCooldown(_actionIndex, _actionCooldownDuration)
		}
	}
	
	static ResetAction = function()
	{
		active_action = undefined;
		is_movement_interrupted = false;
		action_duration_timer.StopTimer();
	}
	
	static ResetActionCooldown = function(_actionIndex)
	{
		var actionCooldown = action_cooldowns[_actionIndex];
		if (!is_undefined(actionCooldown)) actionCooldown.cooldown_timer.TriggerTimer();
	}
	
	static IsActionInCooldown = function(_actionIndex)
	{
		var isActionInCooldown = false;
		var actionCooldown = action_cooldowns[@ _actionIndex];
		if (!is_undefined(actionCooldown))
		{
			isActionInCooldown = !actionCooldown.cooldown_timer.IsTimerStopped();
		}
		return isActionInCooldown;
	}
}