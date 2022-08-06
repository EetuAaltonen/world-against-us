if (initLoot)
{
	initLoot = false;
	
	// Set known to false
	loot.AddItem(global.ItemData[? "Ak-47"].Clone(), noone, false);
	loot.AddItem(global.ItemData[? "MP5"].Clone(), noone, false);
	loot.AddItem(global.ItemData[? "Army Helmet"], noone, false);
	loot.AddItem(global.ItemData[? "Knife"], noone, false);
	loot.AddItem(global.ItemData[? "Hand Grenade"], noone, false);
	loot.AddItem(global.ItemData[? "Water Bottle"], noone, false);
}
