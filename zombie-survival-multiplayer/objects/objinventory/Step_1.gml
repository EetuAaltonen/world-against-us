if (initInventory && global.ItemData != noone)
{
	initInventory = false;
	
	inventory.AddItem(global.ItemData[? "Water Bottle"].Clone());
}
