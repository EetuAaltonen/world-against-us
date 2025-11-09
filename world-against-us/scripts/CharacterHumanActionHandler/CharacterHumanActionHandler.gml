function CharacterHumanActionHandler() constructor
{
	active_action = undefined;
	action_timer = new Timer(-1);
	action_cooldowns = undefined;
	is_initialized = false;
	
	Initialize();
	
	static OnDestroy = function(_struct = self)
	{
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
		// UPDATE ACTION COOLDOWNS
		UpdateActionCooldowns();
		
		if (!is_undefined(active_action))
		{
			// UPDATE ACTIVE ACTION TIMER
			action_timer.Update();
			if (action_timer.IsTimerStopped())
			{
				ResetAction();
			}
		}
	}
	
	static UpdateActionCooldowns = function()
	{
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
	
	static GetActionIndex = function()
	{
		var actionIndex = undefined;
		if (!is_undefined(active_action))
		{
			actionIndex = active_action.action_index;
		}
		return actionIndex;
	}
	
	static SetAction = function(_activeAction, _overrideActiveAction)
	{
		var isActionSet = false;
		if (_overrideActiveAction)
		{
			if (!is_undefined(active_action))
			{
				// CAN'T INTERRUPT ACTIVE ACTION
				if (!active_action.is_interruptible) return isActionSet;
			}
		}
		
		if (is_undefined(active_action) || _overrideActiveAction)
		{
			active_action = _activeAction;
			if (!is_undefined(_activeAction.action_duration))
			{
				action_timer.setting_time = _activeAction.action_duration;
				action_timer.StartTimer();
			} else if (!is_undefined(_activeAction.action_animation))
			{
				_activeAction.instance_ref.skeletalAnimator.SetActiveAnimation(_activeAction.action_animation);
			}
			isActionSet = true;
		}
		return isActionSet;
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
		if (!is_undefined(active_action))
		{
			// SET ACTION TO COOLDOWN
			if (!is_undefined(active_action.action_cooldown))
			{
				SetActionCooldown(active_action.action_index, active_action.action_cooldown);
			} else if (!is_undefined(active_action.action_animation))
			{
				var animatorRef = active_action.instance_ref.skeletalAnimator;
				if (!is_undefined(animatorRef))
				{
					// RESET DEFAULT ANIMATION
					animatorRef.ResetActiveAnimation();
				}
			}
		
			// DELETE ACTIVE ACTION
			ReleaseVariableFromMemory(active_action);
			active_action = undefined;
			
			// TRIGGER ACTION TIMER
			action_timer.StopTimer();
		}
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