function CollisionBodyPart(_total_hitpoints, _is_vital_part, _bounding_box) constructor
{
	total_hitpoints = _total_hitpoints;
	hitpoints = total_hitpoints;
	is_vital_part = _is_vital_part;
	bounding_box = _bounding_box;
	
	static TakeDamage = function(_damage)
	{
		hitpoints = max(0, hitpoints - _damage);
	}
	
	static RestoreHealth = function(_amount)
	{
		hitpoints = min(total_hitpoints, hitpoints + _amount);
	}
}