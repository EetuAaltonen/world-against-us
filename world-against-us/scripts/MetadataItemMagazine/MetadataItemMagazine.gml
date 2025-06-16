function MetadataItemMagazine(_caliber, _capacity) : Metadata() constructor
{
	caliber = _caliber;
    capacity = _capacity;
	bullets = [];
	
	static ToJSONStruct = function()
	{
		return {
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
		return array_push(bullets, _ammo.name);;
	}
	
	static UnloadAmmo = function()
	{
		return array_pop(bullets);
	}
}