function ParseJSONStructToDatabaseItemMetadata(_jsonStruct, _itemCategory, _itemType)
{
	var parsedMetadata = undefined;	
	try
	{
		if (is_undefined(_jsonStruct)) return parsedMetadata;
		var metadataStruct = is_string(_jsonStruct) ? json_parse(_jsonStruct) : _jsonStruct;
		if (variable_struct_names_count(metadataStruct) <= 0) return parsedMetadata;
		
		if (is_undefined(_itemCategory)) return parsedMetadata;
		
		switch (_itemCategory)
		{
			case "Weapon":
			{
				if (_itemType == "Melee")
				{
					parsedMetadata = new MetadataItemWeaponMelee(
						metadataStruct[$ "fire_rate"] ?? undefined,
						metadataStruct[$ "range"] ?? undefined,
						metadataStruct[$ "kickback"] ?? undefined,
						metadataStruct[$ "weapon_offset"] ?? undefined,
						metadataStruct[$ "chamber_pos"] ?? undefined,
						metadataStruct[$ "barrel_pos"] ?? undefined,
						metadataStruct[$ "right_hand_position"] ?? undefined,
						metadataStruct[$ "left_hand_position"] ?? undefined,
						metadataStruct[$ "base_damage"] ?? undefined
					);
				} else if (_itemType == "Shotgun")
				{
					parsedMetadata = new MetadataItemWeaponGunShotgun(
						metadataStruct[$ "fire_rate"] ?? undefined,
						metadataStruct[$ "range"] ?? undefined,
						metadataStruct[$ "kickback"] ?? undefined,
						metadataStruct[$ "weapon_offset"] ?? undefined,
						metadataStruct[$ "chamber_pos"] ?? undefined,
						metadataStruct[$ "barrel_pos"] ?? undefined,
						metadataStruct[$ "right_hand_position"] ?? undefined,
						metadataStruct[$ "left_hand_position"] ?? undefined,
						metadataStruct[$ "chamber_type"] ?? undefined,
						metadataStruct[$ "caliber"] ?? undefined,
						metadataStruct[$ "recoil"] ?? undefined,
						metadataStruct[$ "attachment_slots"] ?? undefined,
						metadataStruct[$ "shell_capacity"] ?? undefined
					);
				} else if (_itemType == "Flamethrower")
				{
					parsedMetadata = new MetadataItemWeaponGunFlamethrower(
						metadataStruct[$ "fire_rate"] ?? undefined,
						metadataStruct[$ "range"] ?? undefined,
						metadataStruct[$ "kickback"] ?? undefined,
						metadataStruct[$ "weapon_offset"] ?? undefined,
						metadataStruct[$ "chamber_pos"] ?? undefined,
						metadataStruct[$ "barrel_pos"] ?? undefined,
						metadataStruct[$ "right_hand_position"] ?? undefined,
						metadataStruct[$ "left_hand_position"] ?? undefined,
						metadataStruct[$ "chamber_type"] ?? undefined,
						metadataStruct[$ "caliber"] ?? undefined,
						metadataStruct[$ "recoil"] ?? undefined,
						metadataStruct[$ "attachment_slots"] ?? undefined
					);
				} else {
					parsedMetadata = new MetadataItemWeaponGun(
						metadataStruct[$ "fire_rate"] ?? undefined,
						metadataStruct[$ "range"] ?? undefined,
						metadataStruct[$ "kickback"] ?? undefined,
						metadataStruct[$ "weapon_offset"] ?? undefined,
						metadataStruct[$ "chamber_pos"] ?? undefined,
						metadataStruct[$ "barrel_pos"] ?? undefined,
						metadataStruct[$ "right_hand_position"] ?? undefined,
						metadataStruct[$ "left_hand_position"] ?? undefined,
						metadataStruct[$ "chamber_type"] ?? undefined,
						metadataStruct[$ "caliber"] ?? undefined,
						metadataStruct[$ "recoil"] ?? undefined,
						metadataStruct[$ "attachment_slots"] ?? undefined
					);
				}
			} break;
			case "Magazine":
			{
				parsedMetadata = new MetadataItemMagazine(
					metadataStruct[$ "caliber"] ?? undefined,
					metadataStruct[$ "capacity"] ?? undefined
				);
			} break;
			case "Fuel Ammo":
			{
				parsedMetadata = new MetadataItemFuelAmmo(
					metadataStruct[$ "caliber"] ?? undefined,
					metadataStruct[$ "capacity"] ?? undefined
				);
			} break;
			case "Bullet":
			{
				parsedMetadata = new MetadataItemBullet(
					metadataStruct[$ "base_damage"] ?? undefined,
					metadataStruct[$ "caliber"] ?? undefined,
					metadataStruct[$ "fly_speed"] ?? undefined,
					metadataStruct[$ "projectile"] ?? undefined,
					new RGBAColor(255, 255, 255, 0)
				);
			} break;
			case "Medicine":
			{
				parsedMetadata = new MetadataItemMedicine(
					metadataStruct[$ "healing_value"] ?? undefined
				);
			} break;
			case "Fuel":
			{
				parsedMetadata = new MetadataItemFuel(
					metadataStruct[$ "fuel_value"] ?? undefined
				);
			} break;
			case "Consumable":
			{
				if (_itemType == "Food")
				{
					parsedMetadata = new MetadataItemFood(
						metadataStruct[$ "nutrition"] ?? undefined
					);
				} else if (_itemType == "Liquid")
				{
					parsedMetadata = new MetadataItemLiquid(
						metadataStruct[$ "hydration"] ?? undefined
					);
				}
			} break;
			case "Backpack":
			{
				parsedMetadata = new MetadataItemBackpack(
					metadataStruct[$ "inventory_size"] ?? undefined,
					metadataStruct[$ "max_weight_capacity"] ?? undefined
				);
			} break;
		}
		
		if (is_undefined(parsedMetadata))
		{
			show_message("ParseMetadataItem : Metadata parse error");
			throw (string(metadataStruct));
		}
	} catch (error) {
		show_debug_message(error);
		show_message(error);
	}
	return parsedMetadata;
}