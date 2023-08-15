function ParseJSONStructToMetadataItem(_metadata, _itemCategory, _itemType)
{
	var parsedMetadata = new Metadata();
	if (!is_undefined(_metadata) && !is_undefined(_itemCategory))
	{
		try
		{
			switch (_itemCategory)
			{
				case "Weapon":
				{
					if (_itemType == "Melee")
					{
						parsedMetadata = new MetadataItemWeaponMelee(
							_metadata[$ "fire_rate"],
							_metadata[$ "range"],
							_metadata[$ "kickback"],
							_metadata[$ "weapon_offset"],
							_metadata[$ "chamber_pos"],
							_metadata[$ "barrel_pos"],
							_metadata[$ "right_hand_position"],
							_metadata[$ "left_hand_position"],
							_metadata[$ "base_damage"]
						);
					} else if (_itemType == "Shotgun")
					{
						parsedMetadata = new MetadataItemWeaponGunShotgun(
							_metadata[$ "fire_rate"],
							_metadata[$ "range"],
							_metadata[$ "kickback"],
							_metadata[$ "weapon_offset"],
							_metadata[$ "chamber_pos"],
							_metadata[$ "barrel_pos"],
							_metadata[$ "right_hand_position"],
							_metadata[$ "left_hand_position"],
							_metadata[$ "chamber_type"],
							_metadata[$ "caliber"],
							_metadata[$ "recoil"],
							_metadata[$ "attachment_slots"],
							_metadata[$ "shell_capacity"]
						);
						
						// VARYING METADATA
						if (!is_undefined(_metadata[$ "shells"]))
						{
							var shells = ParseJSONStructToArray(_metadata[$ "shells"], ParseJSONStructToItem);
							variable_struct_set(parsedMetadata, "shells", shells);
						}
					} else if (_itemType == "Flamethrower")
					{
						parsedMetadata = new MetadataItemWeaponGunFlamethrower(
							_metadata[$ "fire_rate"],
							_metadata[$ "range"],
							_metadata[$ "kickback"],
							_metadata[$ "weapon_offset"],
							_metadata[$ "chamber_pos"],
							_metadata[$ "barrel_pos"],
							_metadata[$ "right_hand_position"],
							_metadata[$ "left_hand_position"],
							_metadata[$ "chamber_type"],
							_metadata[$ "caliber"],
							_metadata[$ "recoil"],
							_metadata[$ "attachment_slots"]
						);
						
						// VARYING METADATA
						if (!is_undefined(_metadata[$ "fuel_tank"] ?? undefined)) { variable_struct_set(parsedMetadata, "fuel_tank", _metadata[$ "fuel_tank"]); }
					} else {
						parsedMetadata = new MetadataItemWeaponGun(
							_metadata[$ "fire_rate"],
							_metadata[$ "range"],
							_metadata[$ "kickback"],
							_metadata[$ "weapon_offset"],
							_metadata[$ "chamber_pos"],
							_metadata[$ "barrel_pos"],
							_metadata[$ "right_hand_position"],
							_metadata[$ "left_hand_position"],
							_metadata[$ "chamber_type"],
							_metadata[$ "caliber"],
							_metadata[$ "recoil"],
							_metadata[$ "attachment_slots"]
						);
						
						// VARYING METADATA
						if (!is_undefined(_metadata[$ "magazine"] ?? undefined)) { variable_struct_set(parsedMetadata, "magazine", _metadata[$ "magazine"]); }
					}
				} break;
				case "Magazine":
				{
					parsedMetadata = new MetadataItemMagazine(
						_metadata[$ "caliber"],
						_metadata[$ "capacity"]
					);
					
					// VARYING METADATA
					if (!is_undefined(_metadata[$ "bullets"]))
					{
						var bullets = ParseJSONStructToArray(_metadata[$ "bullets"], ParseJSONStructToItem);
						variable_struct_set(parsedMetadata, "bullets", bullets);
					}
				} break;
				case "Fuel Ammo":
				{
					parsedMetadata = new MetadataItemFuelAmmo(
						_metadata[$ "caliber"],
						_metadata[$ "capacity"]
					);
					
					// VARYING METADATA
					if (!is_undefined(_metadata[$ "fuel_level"]))
					{
						parsedMetadata.fuel_level = _metadata[$ "fuel_level"];
					}
				} break;
				case "Bullet":
				{
					var trailRGBAColorStruct = _metadata[$ "trail_rgba_color"];
					var trailRGBAColor = new RGBAColor(
						trailRGBAColorStruct[$ "red"] ?? 255,
						trailRGBAColorStruct[$ "green"] ?? 255,
						trailRGBAColorStruct[$ "blue"] ?? 255,
						trailRGBAColorStruct[$ "alpha"] ?? 0
					);
					
					parsedMetadata = new MetadataItemBullet(
						_metadata[$ "base_damage"],
						_metadata[$ "caliber"],
						_metadata[$ "fly_speed"],
						_metadata[$ "projectile"],
						trailRGBAColor
					);
				} break;
				case "Medicine":
				{
					parsedMetadata = new MetadataItemMedicine(
						_metadata[$ "healing_value"]
					);
					
					// VARYING METADATA
					if (!is_undefined(_metadata[$ "healing_left"])) { variable_struct_set(parsedMetadata, "healing_left", _metadata[$ "healing_left"]); }
				} break;
				case "Fuel":
				{
					parsedMetadata = new MetadataItemFuel(
						_metadata[$ "fuel_value"]
					);
					
					// VARYING METADATA
					if (!is_undefined(_metadata[$ "fuel_left"])) { variable_struct_set(parsedMetadata, "fuel_left", _metadata[$ "fuel_left"]); }
				} break;
				case "Consumable":
				{
					if (_itemType == "Food")
					{
						parsedMetadata = new MetadataItemFood(
							_metadata[$ "nutrition"]
						);
					} else if (_itemType == "Liquid")
					{
						parsedMetadata = new MetadataItemLiquid(
							_metadata[$ "hydration"]
						);
					}
				} break;
			}
			
			if (is_undefined(parsedMetadata))
			{
				show_message("ParseMetadataItem : Metadata parse error");
				throw (string(_metadata))
			}
		} catch (error) {
			show_debug_message(error);
			show_message(error);
		}
	}
	return parsedMetadata;
}