function ItemParseMetadata(_metadata, _itemType)
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
			} break;
			case "Magazine":
			{
				parsedMetadata = new MetadataMagazine(
					_metadata[$ "caliber"],
					_metadata[$ "magazine_size"]
				);
			} break;
			case "Ammo":
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