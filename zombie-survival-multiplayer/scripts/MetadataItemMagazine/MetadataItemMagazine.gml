function MetadataItemMagazine(_caliber, _capacity) : Metadata() constructor
{
	caliber = _caliber;
    capacity = _capacity;
	bullets = [];
	
	static ToJSONStruct = function()
	{
		var bulletArray = [];
		var bulletCount = GetAmmoCount();
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
	
	static GetAmmoCount = function()
	{
		return array_length(bullets);
	}
	
	static GetAmmoCapacity = function()
	{
		return capacity;
	}
	
	static ReloadAmmo = function(_ammo)
	{
		_ammo.sourceInventory = undefined;
		return array_push(bullets, _ammo);
	}
	
	static UnloadAmmo = function()
	{
		return array_pop(bullets);
	}
}