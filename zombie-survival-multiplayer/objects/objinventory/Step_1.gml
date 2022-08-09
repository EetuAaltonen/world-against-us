if (initInventory && global.ItemData != noone)
{
	initInventory = false;
	
	// ADD SOME STARTING SUPPLIES
	inventory.AddItem(global.ItemData[? "Money"].Clone(100));
	inventory.AddItem(global.ItemData[? "Ak-47"].Clone());
	inventory.AddItem(global.ItemData[? "Water Bottle"].Clone());
}
