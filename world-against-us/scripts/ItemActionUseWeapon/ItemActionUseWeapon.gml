function ItemActionUseWeapon(_item)
{
	if (_item.sourceInventory.type == INVENTORY_TYPE.PlayerBackpack)
	{
		var gearSlots = global.PlayerCharacter.gear;
		if (!is_undefined(gearSlots))
		{
			gearSlots.EquipItemBySlot(_item, gearSlots.primary_weapon);
			var playerBackpackWindow = global.GameWindowHandlerRef.GetWindowById(GAME_WINDOW.PlayerBackpack);
			if (!is_undefined(playerBackpackWindow))
			{
				var gearSlotprimaryWeapon = playerBackpackWindow.GetChildElementById("PrimaryWeaponSlot");
				if (!is_undefined(gearSlotprimaryWeapon))
				{
					gearSlotprimaryWeapon.initItem = true;
				}
			}
		}
	}
}