function ParseMetadataItem(_metadata, _itemType)
{
	var parsedMetadata = new Metadata();
	if (!is_undefined(_metadata) && !is_undefined(_itemType))
	{
		switch (_itemType)
		{
			case "Primary_Weapon":
			{
				parsedMetadata = new MetadataItemWeapon(
					_metadata[$ "caliber"],
					_metadata[$ "fire_rate"],
					_metadata[$ "range"],
					_metadata[$ "recoil"],
					_metadata[$ "attachment_slots"],
					_metadata[$ "barrel_pos"]
				);
				if (!is_undefined(_metadata[$ "magazine"] ?? undefined)) { variable_struct_set(parsedMetadata, "magazine", _metadata[$ "magazine"]); }
			} break;
			case "Magazine":
			{
				parsedMetadata = new MetadataItemMagazine(
					_metadata[$ "caliber"],
					_metadata[$ "capacity"]
				);
				if (!is_undefined(_metadata[$ "bullets"]))
				{
					var bullets = ParseJSONStructToArray(_metadata[$ "bullets"], ParseJSONStructToItem);
					variable_struct_set(parsedMetadata, "bullets", bullets);
				}
			} break;
			case "Bullet":
			{
				parsedMetadata = new MetadataItemBullet(
					_metadata[$ "caliber"]
				);
			} break;
			case "Medicine":
			{
				parsedMetadata = new MetadataItemMedicine(
					_metadata[$ "healing_value"]
				);
				if (!is_undefined(_metadata[$ "healing_left"])) { variable_struct_set(parsedMetadata, "healing_left", _metadata[$ "healing_left"]); }
			} break;
			case "Fuel":
			{
				parsedMetadata = new MetadataItemFuel(
					_metadata[$ "fuel_value"]
				);
				if (!is_undefined(_metadata[$ "fuel_left"])) { variable_struct_set(parsedMetadata, "fuel_left", _metadata[$ "fuel_left"]); }
			} break;
			case "Consumable":
			{
				var consumableType = _metadata[$ "consumable_type"];
				if (consumableType == "Food")
				{
					parsedMetadata = new MetadataItemFood(
						_metadata[$ "consumable_type"],
						_metadata[$ "nutrition"]
					);
				} else if (consumableType == "Liquid")
				{
					parsedMetadata = new MetadataItemLiquid(
						_metadata[$ "consumable_type"],
						_metadata[$ "hydration"]
					);
				}
			} break;
		}
	}
	return parsedMetadata;
}