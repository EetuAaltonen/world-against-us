function MetadataItemBullet(_base_damage, _caliber, _fly_speed, _projectile, _trail_rgba_color) : Metadata() constructor
{
	base_damage = _base_damage;
	caliber = _caliber;
	fly_speed = _fly_speed;
	projectile = _projectile;
	trail_rgba_color = _trail_rgba_color;
	
	static ToJSONStruct = function()
	{
		return {
			// NO DYNAMIC METADATA
		}
	}
	
	static Clone = function()
	{
		return new MetadataItemBullet(
			base_damage,
			caliber,
			fly_speed,
			projectile,
			trail_rgba_color.Clone()
		);
	}
	
	static OnDestroy = function(_struct = self)
	{
		ReleaseVariableFromMemory(_struct.trail_rgba_color);
		_struct.trail_rgba_color = undefined;
	}
}