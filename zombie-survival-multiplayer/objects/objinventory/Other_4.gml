// ADD SOME STARTING SUPPLIES
if (ds_list_size(inventory.items) <= 0)
{
	inventory.AddItem(global.ItemData[? "Money"].Clone(100), undefined, true, true);
	inventory.AddItem(global.ItemData[? "Water Bottle"].Clone(), undefined, true, true);
	inventory.AddItem(global.ItemData[? "Ak-47"].Clone(), undefined, true, true);
	
	inventory.AddItem(global.ItemData[? "Ak-47 Mag"].Clone(), undefined, true, true);
	inventory.AddItem(global.ItemData[? "Ak-47 Mag"].Clone(), undefined, true, true);
	inventory.AddItem(global.ItemData[? "Ak-47 Mag"].Clone(), undefined, true, true);
	
	inventory.AddItem(global.ItemData[? "7.62 Bullet"].Clone(110), undefined, true, true);
	
	inventory.AddItem(global.ItemData[? "Bandage"].Clone(), undefined, true, true);
	inventory.AddItem(global.ItemData[? "First Aid Kit"].Clone(), undefined, true, true);
	
	inventory.AddItem(global.ItemData[? "Canned Meat"].Clone(), undefined, true, true);
	inventory.AddItem(global.ItemData[? "Snickers Bar"].Clone(), undefined, true, true);
}