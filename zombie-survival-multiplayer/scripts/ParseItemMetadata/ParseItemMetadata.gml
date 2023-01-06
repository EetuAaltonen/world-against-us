function ParseItemMetadata(_metadata, _itemType)
{
	var parsedMetadata = new Metadata();
	if (!is_undefined(_metadata) && !is_undefined(_itemType))
	{
		switch (_itemType)
		{
			case "Primary_Weapon":
			{
				parsedMetadata = new MetadataPrimaryWeapon(
					_metadata[$ "caliber"],
					_metadata[$ "fire_rate"],
					_metadata[$ "range"],
					_metadata[$ "recoil"],
					_metadata[$ "attachment_slots"],
					_metadata[$ "barrel_pos"]
				);
				if (!is_undefined(_metadata[$ "magazine"]) && !is_ptr(_metadata[$ "magazine"])) { variable_struct_set(parsedMetadata, "magazine", _metadata[$ "magazine"]); }
			} break;
			case "Magazine":
			{
				parsedMetadata = new MetadataMagazine(
					_metadata[$ "caliber"],
					_metadata[$ "magazine_size"]
				);
				if (!is_undefined(_metadata[$ "bullet_count"])) { variable_struct_set(parsedMetadata, "bullet_count", _metadata[$ "bullet_count"]); }
			} break;
			case "Bullet":
			{
				parsedMetadata = new MetadataAmmo(
					_metadata[$ "caliber"]
				);
			} break;
			case "Medicine":
			{
				parsedMetadata = new MetadataMedicine(
					_metadata[$ "healing_value"]
				);
				if (!is_undefined(_metadata[$ "healing_left"])) { variable_struct_set(parsedMetadata, "healing_left", _metadata[$ "healing_left"]); }
			} break;
			case "Fuel":
			{
				parsedMetadata = new MetadataFuel(
					_metadata[$ "fuel_value"]
				);
				if (!is_undefined(_metadata[$ "fuel_left"])) { variable_struct_set(parsedMetadata, "fuel_left", _metadata[$ "fuel_left"]); }
			} break;
			case "Consumable":
			{
				var consumableType = _metadata[$ "consumable_type"];
				if (consumableType == "Food")
				{
					parsedMetadata = new MetadataConsumableFood(
						_metadata[$ "consumable_type"],
						_metadata[$ "nutrition"]
					);
				} else if (consumableType == "Liquid")
				{
					parsedMetadata = new MetadataConsumableLiquid(
						_metadata[$ "consumable_type"],
						_metadata[$ "hydration"]
					);
				}
			} break;
		}
	}
	return parsedMetadata;
}