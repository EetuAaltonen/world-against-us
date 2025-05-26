function AIBase(_instanceRef, _aiStates, _defaultAIStateIndex) constructor
{
	instance_ref = _instanceRef;
	state_machine = new AIStateMachine(_aiStates, _defaultAIStateIndex);
	
	// CALL OnCreate
	
	static OnCreate = function()
	{
		// OVERRIDE THIS FUNCTION
		return;
	}
	
	static OnDestroy = function(_struct = self)
	{
		// OVERRIDE THIS FUNCTION
		return;
	}
	
	static OnRoomStart = function()
	{
		// OVERRIDE THIS FUNCTION
		return;
	}
	
	static BeginUpdate = function()
	{
		// OVERRIDE THIS FUNCTION
		return;
	}
	
	static Update = function()
	{
		// OVERRIDE THIS FUNCTION
		return;
	}
	
	static EndUpdate = function()
	{
		// OVERRIDE THIS FUNCTION
		return;
	}
	
	static OnDead = function()
	{
		// OVERRIDE THIS FUNCTION
		return;
	}
	
	static GetStateIndex = function()
	{
		return state_machine.state_index;
	}
}