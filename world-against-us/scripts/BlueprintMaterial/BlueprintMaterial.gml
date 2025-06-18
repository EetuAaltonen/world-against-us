function BlueprintMaterial(_name, _quantity) constructor
{
	name = _name;
	quantity = _quantity;
	
	static OnDestroy = function(_struct = self)
	{
		// NO GARBAGE CLEANING
	}
	
	static Clone = function()
	{
		return new BlueprintMaterial(
			name,
			quantity
		);
	}
}