function AIBase(_instanceRef, _aiStates, _defaultAIStateIndex) constructor
{
	instance_ref = _instanceRef;
	state_machine = new AIStateMachine(_aiStates, _defaultAIStateIndex);
	
	// CALL OnCreate
	
	static OnCreate = function()
	{
		// OVERDRIVE THIS FUNCTION
		return;
	}
	
	static OnDestroy = function(_struct = self)
	{
		// OVERDRIVE THIS FUNCTION
		return;
	}
	
	static OnRoomStart = function()
	{
		// OVERDRIVE THIS FUNCTION
		return;
	}
	
	static BeginUpdate = function()
	{
		// OVERDRIVE THIS FUNCTION
		return;
	}
	
	static Update = function()
	{
		// OVERDRIVE THIS FUNCTION
		return;
	}
	
	static EndUpdate = function()
	{
		// OVERDRIVE THIS FUNCTION
		return;
	}
	
	static GetStateIndex = function()
	{
		return state_machine.state_index;
	}
}