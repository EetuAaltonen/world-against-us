function Character(_name, _type, _maxHp = 100, _maxStamina = 100) constructor
{
	name = _name;
	type = _type;
	
	maxHp = _maxHp;
	hp = maxHp;
	maxStamina = _maxStamina;
	stamina = maxStamina;
	
	static Clone = function(_hp = undefined, _stamina = undefined)
	{
		var clone = new Character(
			name, characterType,
			maxHp, maxStamina
		);
		clone.hp = _hp ?? maxHp;
		close.stamina = _stamina ?? maxStamina;
		return clone;
	}
	
	static TakeDamage = function(_damage)
	{
		hp = max(0, hp - _damage);
	}
	
	static Heal = function(_amount)
	{
		hp = min(maxHp, hp + _amount);
	}
}
