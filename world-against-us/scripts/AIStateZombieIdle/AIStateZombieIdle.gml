function AIStateZombieIdle(_aiBase)
{
	if (_aiBase.state_machine.state_timer.IsTimerStopped())
	{
		_aiBase.state_machine.SetState(AI_STATE_ZOMBIE.WANDER);
	}
}