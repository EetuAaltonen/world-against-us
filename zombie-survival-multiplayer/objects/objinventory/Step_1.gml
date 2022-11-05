if (initInventory && global.ItemData != noone)
{
	initInventory = false;
	
	// ADD SOME STARTING SUPPLIES
	inventory.AddItem(global.ItemData[? "Money"].Clone(100), noone, true, true);
	inventory.AddItem(global.ItemData[? "Water Bottle"].Clone(), noone, true, true);
	inventory.AddItem(global.ItemData[? "Ak-47"].Clone(), noone, true, true);
}
