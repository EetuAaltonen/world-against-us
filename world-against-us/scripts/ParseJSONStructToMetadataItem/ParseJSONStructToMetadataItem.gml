function ParseJSONStructToMetadataItem(_jsonStruct, _itemCategory, _itemType)
{
	var parsedMetadata = undefined;
	if (!is_undefined(_jsonStruct) && !is_undefined(_itemCategory))
	{
		var metadataStruct = is_string(_jsonStruct) ? json_parse(_jsonStruct) : _jsonStruct;
		if (variable_struct_names_count(metadataStruct) <= 0) return parsedMetadata;
		
		try
		{
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
						
						// VARYING METADATA
						if (!is_undefined(metadataStruct[$ "shells"] ?? undefined))
						{
							var shells = ParseJSONStructToArray(metadataStruct[$ "shells"], ParseJSONStructToItem);
							variable_struct_set(parsedMetadata, "shells", shells);
						}
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
						
						// VARYING METADATA
						if (!is_undefined(metadataStruct[$ "fuel_tank"] ?? undefined)) { variable_struct_set(parsedMetadata, "fuel_tank", metadataStruct[$ "fuel_tank"]); }
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
						
						// VARYING METADATA
						if (!is_undefined(metadataStruct[$ "magazine"] ?? undefined)) { variable_struct_set(parsedMetadata, "magazine", metadataStruct[$ "magazine"]); }
					}
				} break;
				case "Magazine":
				{
					parsedMetadata = new MetadataItemMagazine(
						metadataStruct[$ "caliber"] ?? undefined,
						metadataStruct[$ "capacity"] ?? undefined
					);
					
					// VARYING METADATA
					if (!is_undefined(metadataStruct[$ "bullets"] ?? undefined))
					{
						var bullets = ParseJSONStructToArray(metadataStruct[$ "bullets"], ParseJSONStructToItem);
						variable_struct_set(parsedMetadata, "bullets", bullets);
					}
				} break;
				case "Fuel Ammo":
				{
					parsedMetadata = new MetadataItemFuelAmmo(
						metadataStruct[$ "caliber"] ?? undefined,
						metadataStruct[$ "capacity"] ?? undefined
					);
					
					// VARYING METADATA
					if (!is_undefined(metadataStruct[$ "fuel_left"] ?? undefined)) { variable_struct_set(parsedMetadata, "fuel_left", metadataStruct[$ "fuel_left"]); }
				} break;
				case "Bullet":
				{
					var parsedTrailRGBAColor = undefined;
					var trailRGBAColorStruct = metadataStruct[$ "trail_rgba_color"] ?? undefined;
					if (!is_undefined(metadataStruct[$ "fuel_left"] ?? undefined))
					{
						parsedTrailRGBAColor = new RGBAColor(
							trailRGBAColorStruct[$ "red"] ?? 255,
							trailRGBAColorStruct[$ "green"] ?? 255,
							trailRGBAColorStruct[$ "blue"] ?? 255,
							trailRGBAColorStruct[$ "alpha"] ?? 0
						);
					}
					
					parsedMetadata = new MetadataItemBullet(
						metadataStruct[$ "base_damage"] ?? undefined,
						metadataStruct[$ "caliber"] ?? undefined,
						metadataStruct[$ "fly_speed"] ?? undefined,
						metadataStruct[$ "projectile"] ?? undefined,
						parsedTrailRGBAColor
					);
				} break;
				case "Medicine":
				{
					parsedMetadata = new MetadataItemMedicine(
						metadataStruct[$ "healing_value"] ?? undefined
					);
					
					// VARYING METADATA
					if (!is_undefined(metadataStruct[$ "healing_left"] ?? undefined)) { variable_struct_set(parsedMetadata, "healing_left", metadataStruct[$ "healing_left"]); }
				} break;
				case "Fuel":
				{
					parsedMetadata = new MetadataItemFuel(
						metadataStruct[$ "fuel_value"] ?? undefined
					);
					
					// VARYING METADATA
					if (!is_undefined(metadataStruct[$ "fuel_left"] ?? undefined)) { variable_struct_set(parsedMetadata, "fuel_left", metadataStruct[$ "fuel_left"]); }
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
					
					// VARYING METADATA
					if (!is_undefined(metadataStruct[$ "inventory"] ?? undefined)) { variable_struct_set(parsedMetadata, "inventory", metadataStruct[$ "inventory"]); }
					if (!is_undefined(metadataStruct[$ "inventory_content"] ?? undefined))
					{
						var inventoryContent = metadataStruct[$ "inventory_content"];
						var inventoryId = inventoryContent[$ "inventory_id"] ?? undefined;
						if (!is_undefined(inventoryId))
						{
							parsedMetadata.InitInventory(inventoryId, inventoryContent[$ "inventory_type"] ?? INVENTORY_TYPE.BackpackSlot);
							
							var itemsStruct = inventoryContent[$ "items"] ?? [];
							var parsedItems = ParseJSONStructToArray(itemsStruct, ParseJSONStructToItem);
							parsedMetadata.inventory.AddMultipleItems(parsedItems);
						}
					}
				} break;
			}
			
			if (is_undefined(parsedMetadata))
			{
				show_message("ParseMetadataItem : Metadata parse error");
				throw (string(metadataStruct))
			}
		} catch (error) {
			show_debug_message(error);
			show_message(error);
		}
	}
	return parsedMetadata;
}