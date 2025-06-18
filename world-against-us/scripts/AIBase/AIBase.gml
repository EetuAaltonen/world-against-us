function AIBase(_instanceRef, _aiStates, _defaultAIStateIndex) constructor
{
	instance_ref = _instanceRef;
	state_machine = new AIStateMachine(_aiStates, _defaultAIStateIndex);
	
	// CALL OnCreate
	
	static OnCreate = function()
	{
		// OVERRIDE THIS FUNCTION
	}
	
	static OnDestroy = function(_struct = self)
	{
		// NO GARBAGE CLEANING
	}
	
	static OnRoomStart = function()
	{
		// OVERRIDE THIS FUNCTION
	}
	
	static BeginUpdate = function()
	{
		// OVERRIDE THIS FUNCTION
	}
	
	static Update = function()
	{
		// OVERRIDE THIS FUNCTION
	}
	
	static EndUpdate = function()
	{
		// OVERRIDE THIS FUNCTION
	}
	
	static OnDead = function()
	{
		// OVERRIDE THIS FUNCTION
	}
	
	static GetStateIndex = function()
	{
		return state_machine.state_index;
	}
}