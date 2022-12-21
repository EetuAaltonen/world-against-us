function CharacterBodyPart(_name) constructor
{
	name = _name;
	
	maxCondition = 100;
	condition = 10;//maxCondition; // TODO: Debugging
	
	static TakeDamage = function(_damage)
	{
		condition = max(0, condition - _damage);
	}
	
	static Heal = function(_amount)
	{
		condition = min(maxCondition, condition + _amount);
	}
}