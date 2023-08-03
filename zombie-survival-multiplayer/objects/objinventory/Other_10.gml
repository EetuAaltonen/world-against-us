/// @description Custom RoomStartEvent
// ADD SOME STARTING SUPPLIES
if (room == roomLoadSave)
{
	if (ds_list_size(inventory.items) <= 0)
	{
		//inventory.AddItem(global.ItemDatabase.GetItemByName("Ak-47 Assault Rifle"), undefined, true, true);
		inventory.AddItem(global.ItemDatabase.GetItemByName("Mossberg Maverick Shotgun"), undefined, true, true);
		//inventory.AddItem(global.ItemDatabase.GetItemByName("Sig Sauer P226 Pistol"), undefined, true, true);
		inventory.AddItem(global.ItemDatabase.GetItemByName("MP5 Submachine gun"), undefined, true, true);
		inventory.AddItem(global.ItemDatabase.GetItemByName("Flamethrower"), undefined, true, true);
		//inventory.AddItem(global.ItemDatabase.GetItemByName("Fire Axe"), undefined, true, true);
		
		inventory.AddItem(global.ItemDatabase.GetItemByName("Flamethrower Fuel Tank"), undefined, true, true);
		
		inventory.AddItem(global.ItemDatabase.GetItemByName("Ak-47 Magazine"), undefined, true, true);
		inventory.AddItem(global.ItemDatabase.GetItemByName("Ak-47 Magazine"), undefined, true, true);
		
		inventory.AddItem(global.ItemDatabase.GetItemByName("MP5 Magazine"), undefined, true, true);
		inventory.AddItem(global.ItemDatabase.GetItemByName("MP5 Magazine"), undefined, true, true);
		
		inventory.AddItem(global.ItemDatabase.GetItemByName("P226 Magazine"), undefined, true, true);
		inventory.AddItem(global.ItemDatabase.GetItemByName("P226 Magazine"), undefined, true, true);
	
		inventory.AddItem(global.ItemDatabase.GetItemByName("12-gauge Shell", 5), undefined, true, true);
		inventory.AddItem(global.ItemDatabase.GetItemByName("12-gauge Shell", 120), undefined, true, true);
		
		inventory.AddItem(global.ItemDatabase.GetItemByName("9mm Bullet", 120), undefined, true, true);
		inventory.AddItem(global.ItemDatabase.GetItemByName("9mm Bullet", 120), undefined, true, true);
		inventory.AddItem(global.ItemDatabase.GetItemByName("7.62 Bullet", 120), undefined, true, true);
		inventory.AddItem(global.ItemDatabase.GetItemByName("7.62 Tracer Bullet", 120), undefined, true, true);

		inventory.AddItem(global.ItemDatabase.GetItemByName("Money", 100), undefined, true, true);
		inventory.AddItem(global.ItemDatabase.GetItemByName("Water Bottle"), undefined, true, true);
		inventory.AddItem(global.ItemDatabase.GetItemByName("Bandage"), undefined, true, true);
		inventory.AddItem(global.ItemDatabase.GetItemByName("First Aid Kit"), undefined, true, true);
	
		inventory.AddItem(global.ItemDatabase.GetItemByName("Canned Meat"), undefined, true, true);
		inventory.AddItem(global.ItemDatabase.GetItemByName("Snickers Bar"), undefined, true, true);
	
		inventory.AddItem(global.ItemDatabase.GetItemByName("Gas Can"), undefined, true, true);
	}
}