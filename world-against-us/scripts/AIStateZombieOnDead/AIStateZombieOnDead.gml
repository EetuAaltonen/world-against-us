function AIStateZombieOnDead(_aiBase)
{
	_aiBase.EndPathing();
	_aiBase.state_machine.SetState(AI_STATE_ZOMBIE.DEAD);
}