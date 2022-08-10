if (initStock)
{
	initStock = false;
	stock = new Inventory(INVENTORY_TYPE.LootContainer);
	
	stock.AddItem(global.ItemData[? "Water Bottle"].Clone());
	stock.AddItem(global.ItemData[? "Water Bottle"].Clone());
	stock.AddItem(global.ItemData[? "Hand Grenade"].Clone());
	stock.AddItem(global.ItemData[? "Hand Grenade"].Clone());
	stock.AddItem(global.ItemData[? "Hand Grenade"].Clone());
	stock.AddItem(global.ItemData[? "Hand Grenade"].Clone());
	stock.AddItem(global.ItemData[? "Hand Grenade"].Clone());
}
