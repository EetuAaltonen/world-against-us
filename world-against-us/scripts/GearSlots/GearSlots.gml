function GearSlots(_namePrefix) constructor
{
	name_prefix = _namePrefix;
	
	helmet = new Inventory(string("{0}_Gear_Slot_Helmet", name_prefix), INVENTORY_TYPE.GearSlot,
		new InventorySize(2, 2), new InventoryFilter([], ["Armor"], ["Helmet"]), 1
	);
	body_armor = new Inventory(string("{0}_Gear_Slot_Armor", name_prefix), INVENTORY_TYPE.GearSlot,
		new InventorySize(2, 3), new InventoryFilter([], ["Armor"], ["Body_armor"]), 1
	);
	backpack = new Inventory(string("{0}_Gear_Slot_Backpack", name_prefix), INVENTORY_TYPE.GearSlot,
		new InventorySize(3, 4), new InventoryFilter([], ["Backpack"], []), 1
	);
	primary_weapon = new Inventory(string("{0}_Gear_Slot_Primary_Weapon", name_prefix), INVENTORY_TYPE.GearSlot,
		new InventorySize(4, 2), new InventoryFilter([], ["Weapon"], []), 1
	);
	secondary_weapon = new Inventory(string("{0}_Gear_Slot_Secondary_Weapon", name_prefix), INVENTORY_TYPE.GearSlot,
		new InventorySize(4, 2), new InventoryFilter([], ["Weapon"], []), 1
	);

	static ToJSONStruct = function()
	{
		var helmetItem = GetItemBySlot(helmet);
		var formatHelmet = (!is_undefined(helmetItem)) ? helmetItem.ToJSONStruct() : undefined;
		
		var bodyArmorItem = GetItemBySlot(body_armor);
		var formatBodyArmor = (!is_undefined(bodyArmorItem)) ? bodyArmorItem.ToJSONStruct() : undefined;
		
		var backpackItem = GetItemBySlot(backpack);
		var formatBackpack = (!is_undefined(backpackItem)) ? backpackItem.ToJSONStruct() : undefined;
		
		var primaryWeaponItem = GetItemBySlot(primary_weapon);
		var formatPrimaryWeapon = (!is_undefined(primaryWeaponItem)) ? primaryWeaponItem.ToJSONStruct() : undefined;
		
		var secondaryWeaponItem = GetItemBySlot(secondary_weapon);
		var formatSecondaryWeapon = (!is_undefined(secondaryWeaponItem)) ? secondaryWeaponItem.ToJSONStruct() : undefined;
		
		return {
			helmet: formatHelmet,
			body_armor: formatBodyArmor,
			backpack: formatBackpack,
			primary_weapon: formatPrimaryWeapon,
			secondary_weapon: formatSecondaryWeapon,
		}
	}
	
	static OnDestroy = function(_struct = self)
	{
		ReleaseVariableFromMemory(_struct.helmet);
		_struct.helmet = undefined;
		ReleaseVariableFromMemory(_struct.body_armor);
		_struct.body_armor = undefined;
		ReleaseVariableFromMemory(_struct.backpack);
		_struct.backpack = undefined;
		ReleaseVariableFromMemory(_struct.primary_weapon);
		_struct.primary_weapon = undefined;
		ReleaseVariableFromMemory(_struct.secondary);
		_struct.secondary = undefined;
	}
	
	static GetItemBySlot = function(_slotRef)
	{
		return _slotRef.GetItemByIndex(0);
	}
	
	static EquipItemBySlot = function(_item, _slotRef)
	{
		var equippedItem = _slotRef.GetItemByIndex(0);
		if (is_undefined(equippedItem))
		{
			var gridIndex = _slotRef.AddItem(_item, undefined, false)
			if (!is_undefined(gridIndex))
			{
				_item.sourceInventory.RemoveItemByGridIndex(_item.grid_index);
			}
		} else {
			_item.sourceInventory.SwapWithRollback(_item, equippedItem);
		}
	}
}