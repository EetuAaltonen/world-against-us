function CharacterBodyPart(_name, _index, _max_condition, _bounding_box) constructor
{
	name = _name;
	index = _index;
	max_condition = _max_condition;
	condition = max_condition;
	bounding_box = _bounding_box;
	
	static TakeDamage = function(_damage)
	{
		condition = max(0, condition - _damage);
	}
	
	static Heal = function(_amount)
	{
		condition = min(max_condition, condition + _amount);
	}
}