function CharacterBodyPart(_name, _max_condition) constructor
{
	name = _name;
	max_condition = _max_condition;
	condition = max_condition;
	
	static TakeDamage = function(_damage)
	{
		condition = max(0, condition - _damage);
	}
	
	static Heal = function(_amount)
	{
		condition = min(max_condition, condition + _amount);
	}
}