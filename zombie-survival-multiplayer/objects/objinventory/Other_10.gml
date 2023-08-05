/// @description Custom RoomStartEvent
// ADD SOME STARTING SUPPLIES
if (room == roomLoadSave)
{
	if (ds_list_size(inventory.items) <= 0)
	{
		//inventory.AddItem(global.ItemDatabase.GetItemByName("Ak-47 Assault Rifle"), undefined, false, true, true);
		inventory.AddItem(global.ItemDatabase.GetItemByName("Mossberg Maverick Shotgun"), undefined, false, true, true);
		//inventory.AddItem(global.ItemDatabase.GetItemByName("Sig Sauer P226 Pistol"), undefined, false, true, true);
		inventory.AddItem(global.ItemDatabase.GetItemByName("MP5 Submachine gun"), undefined, false, true, true);
		//inventory.AddItem(global.ItemDatabase.GetItemByName("Flamethrower"), undefined, false, true, true);
		//inventory.AddItem(global.ItemDatabase.GetItemByName("Fire Axe"), undefined, false, true, true);
		
		//inventory.AddItem(global.ItemDatabase.GetItemByName("Flamethrower Fuel Tank"), undefined, false, true, true);
		
		inventory.AddItem(global.ItemDatabase.GetItemByName("Ak-47 Magazine"), undefined, false, true, true);
		inventory.AddItem(global.ItemDatabase.GetItemByName("Ak-47 Magazine"), undefined, false, true, true);
		
		inventory.AddItem(global.ItemDatabase.GetItemByName("MP5 Magazine"), undefined, false, true, true);
		inventory.AddItem(global.ItemDatabase.GetItemByName("MP5 Magazine"), undefined, false, true, true);
		
		inventory.AddItem(global.ItemDatabase.GetItemByName("P226 Magazine"), undefined, false, true, true);
		inventory.AddItem(global.ItemDatabase.GetItemByName("P226 Magazine"), undefined, false, true, true);
	
		inventory.AddItem(global.ItemDatabase.GetItemByName("12-gauge Shell", 5), undefined, false, true, true);
		inventory.AddItem(global.ItemDatabase.GetItemByName("12-gauge Shell", 120), undefined, false, true, true);
		inventory.AddItem(global.ItemDatabase.GetItemByName("12-gauge Slug Shell", 120), undefined, false, true, true);
		
		inventory.AddItem(global.ItemDatabase.GetItemByName("9mm Bullet", 120), undefined, false, true, true);
		inventory.AddItem(global.ItemDatabase.GetItemByName("9mm Bullet", 120), undefined, false, true, true);
		inventory.AddItem(global.ItemDatabase.GetItemByName("7.62 Bullet", 120), undefined, false, true, true);
		inventory.AddItem(global.ItemDatabase.GetItemByName("7.62 Tracer Bullet", 120), undefined, false, true, true);

		inventory.AddItem(global.ItemDatabase.GetItemByName("Money", 100), undefined, false, true, true);
		inventory.AddItem(global.ItemDatabase.GetItemByName("Water Bottle"), undefined, false, true, true);
		inventory.AddItem(global.ItemDatabase.GetItemByName("Bandage"), undefined, false, true, true);
		inventory.AddItem(global.ItemDatabase.GetItemByName("First Aid Kit"), undefined, false, true, true);
	
		inventory.AddItem(global.ItemDatabase.GetItemByName("Canned Meat"), undefined, false, true, true);
		inventory.AddItem(global.ItemDatabase.GetItemByName("Snickers Bar"), undefined, false, true, true);
	
		inventory.AddItem(global.ItemDatabase.GetItemByName("Gas Can"), undefined, false, true, true);
	}
}