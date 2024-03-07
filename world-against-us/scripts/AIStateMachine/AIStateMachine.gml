function AIStateMachine(_states, _defaultStateIndex) constructor
{
	states = _states;
	default_state_index = _defaultStateIndex;
	state_func = undefined;
	state_index = undefined;
	
	OnCreate();
	
	static OnDestroy = function()
	{
		DestroyDSMapAndDeleteValues(states);
		states = undefined;
	}
	
	static OnCreate = function()
	{
		if (!SetState(default_state_index))
		{
			global.ConsoleHandlerRef.AddConsoleLog("Unable to set default AI state");	
		}
	}
	
	static Update = function(_aiBase)
	{
		return state_func(_aiBase);
	}
	
	static SetState = function(_stateIndex)
	{
		var isStateSet = false;
		var stateFunc = states[? _stateIndex];
		if (!is_undefined(stateFunc))
		{
			state_func = stateFunc;
			state_index = _stateIndex;
			isStateSet = true;	
		}
		
		// CONSOLE LOG
		if (!isStateSet)
		{
			var consoleLog = string("Failed to change AI state from {0} to {1}", state_machine.state_index, AI_STATE_BANDIT.CHASE);
			global.ConsoleHandlerRef.AddConsoleLog(CONSOLE_LOG_TYPE.ERROR, consoleLog);	
		}
		return isStateSet;
	}
}