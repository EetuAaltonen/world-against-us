function BlueprintMaterial(_name, _quantity) constructor
{
	name = _name;
	quantity = _quantity;
	
	static Clone = function()
	{
		return new BlueprintMaterial(
			name, quantity
		);
	}
}