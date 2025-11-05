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
	
	static Clone = function()
	{
		var clone = new MetadataItemMagazine(
			caliber,
			capacity
		);
		array_copy(clone.bullets, 0, bullets, 0, array_length(bullets));
		return clone;
	}
	
	static OnDestroy = function(_struct = self)
	{
		ReleaseVariableFromMemory(_struct.bullets);
		_struct.bullets = undefined;
	}
	
	static GetBulletCount = function()
	{
		return array_length(bullets);
	}
	
	static GetBulletCapacity = function()
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