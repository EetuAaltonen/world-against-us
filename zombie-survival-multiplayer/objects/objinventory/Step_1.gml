if (initInventory && global.ItemData != noone)
{
	initInventory = false;
	
	// ADD SOME STARTING SUPPLIES
	inventory.AddItem(global.ItemData[? "Money"].Clone(100), noone, true, true);
	inventory.AddItem(global.ItemData[? "Water Bottle"].Clone(), noone, true, true);
	inventory.AddItem(global.ItemData[? "Ak-47"].Clone(), noone, true, true);
	
	
	inventory.AddItem(global.ItemData[? "Ak-47 Mag"].Clone(), noone, true, true);
	inventory.AddItem(global.ItemData[? "Ak-47 Mag"].Clone(), noone, true, true);
	inventory.AddItem(global.ItemData[? "Ak-47 Mag"].Clone(), noone, true, true);
	
	inventory.AddItem(global.ItemData[? "7.62 Bullet"].Clone(110), noone, true, true);
	
	inventory.AddItem(global.ItemData[? "Bandage"].Clone(), noone, true, true);
	inventory.AddItem(global.ItemData[? "First Aid Kit"].Clone(), noone, true, true);
	
	inventory.AddItem(global.ItemData[? "Canned Meat"].Clone(), noone, true, true);
	inventory.AddItem(global.ItemData[? "Snickers Bar"].Clone(), noone, true, true);
}
