if (initLoot)
{
	initLoot = false;
	inventory = new Inventory(INVENTORY_TYPE.LootContainer);
	
	// SET KNOWN TO FALSE
	inventory.AddItem(global.ItemData[? "MP5"].Clone(), noone, false);
	inventory.AddItem(global.ItemData[? "Army Helmet"].Clone(), noone, false);
	inventory.AddItem(global.ItemData[? "Knife"].Clone(), noone, false);
	inventory.AddItem(global.ItemData[? "Hand Grenade"].Clone(), noone, false);
	inventory.AddItem(global.ItemData[? "Water Bottle"].Clone(), noone, false);
}
