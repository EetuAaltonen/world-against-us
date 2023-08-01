function MetadataItemBullet(_base_damage, _caliber, _projectile, _trail_rgba_color) : Metadata() constructor
{
	base_damage = _base_damage;
	caliber = _caliber;
	projectile = _projectile;
	trail_rgba_color = _trail_rgba_color;
	
	static ToJSONStruct = function()
	{
		var formatrailRGBColor = trail_rgba_color.ToJSONStruct();
		return {
			base_damage: base_damage,
			caliber: caliber,
			projectile: projectile,
			trail_rgba_color: formatrailRGBColor
		}
	}
}