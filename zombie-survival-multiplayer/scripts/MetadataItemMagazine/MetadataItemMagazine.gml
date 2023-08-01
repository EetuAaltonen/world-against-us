function MetadataItemMagazine(_caliber, _capacity) : Metadata() constructor
{
	caliber = _caliber;
    capacity = _capacity;
	bullets = [];
	
	static ToJSONStruct = function()
	{
		var bulletArray = [];
		var bulletCount = GetBulletCount();
		for (var i = 0; i < bulletCount; i++)
		{
			var bullet = bullets[@ i];
			array_push(bulletArray, bullet.ToJSONStruct());
		}
		
		return {
			caliber: caliber,
			capacity: capacity,
			bullets: bullets
		}
	}
	
	static GetBulletCount = function()
	{
		return array_length(bullets);
	}
	
	static LoadBullet = function(_bullet)
	{
		return array_push(bullets, _bullet);
	}
	
	static UnloadBullet = function()
	{
		return array_pop(bullets);
	}
}