if (initLoot)
{
	initLoot = false;
	
	// SET KNOWN TO FALSE
	loot.AddItem(global.ItemData[? "MP5"].Clone(), noone, false);
	loot.AddItem(global.ItemData[? "Army Helmet"].Clone(), noone, false);
	loot.AddItem(global.ItemData[? "Knife"].Clone(), noone, false);
	loot.AddItem(global.ItemData[? "Hand Grenade"].Clone(), noone, false);
	loot.AddItem(global.ItemData[? "Water Bottle"].Clone(), noone, false);
}
