function CharacterBodyPart(_name) constructor
{
	name = _name;
	
	max_condition = 100;
	condition = 10;//max_condition; // TODO: Debugging
	
	static TakeDamage = function(_damage)
	{
		condition = max(0, condition - _damage);
	}
	
	static Heal = function(_amount)
	{
		condition = min(max_condition, condition + _amount);
	}
}