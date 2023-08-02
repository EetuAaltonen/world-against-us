/// @description Custom RoomStartEvent
// ADD SOME STARTING SUPPLIES
if (room == roomLoadSave)
{
	if (ds_list_size(inventory.items) <= 0)
	{
		//inventory.AddItem(global.ItemData[? "Ak-47 Assault Rifle"].Clone(), undefined, true, true);
		inventory.AddItem(global.ItemData[? "Mossberg Maverick Shotgun"].Clone(), undefined, true, true);
		//inventory.AddItem(global.ItemData[? "Sig Sauer P226 Pistol"].Clone(), undefined, true, true);
		inventory.AddItem(global.ItemData[? "MP5 Submachine gun"].Clone(), undefined, true, true);
		inventory.AddItem(global.ItemData[? "Flamethrower"].Clone(), undefined, true, true);
		//inventory.AddItem(global.ItemData[? "Fire Axe"].Clone(), undefined, true, true);
		
		inventory.AddItem(global.ItemData[? "Flamethrower Fuel Tank"].Clone(), undefined, true, true);
		
		inventory.AddItem(global.ItemData[? "Ak-47 Magazine"].Clone(), undefined, true, true);
		inventory.AddItem(global.ItemData[? "Ak-47 Magazine"].Clone(), undefined, true, true);
		
		inventory.AddItem(global.ItemData[? "MP5 Magazine"].Clone(), undefined, true, true);
		inventory.AddItem(global.ItemData[? "MP5 Magazine"].Clone(), undefined, true, true);
		
		inventory.AddItem(global.ItemData[? "P226 Magazine"].Clone(), undefined, true, true);
		inventory.AddItem(global.ItemData[? "P226 Magazine"].Clone(), undefined, true, true);
	
		inventory.AddItem(global.ItemData[? "12-gauge Shell"].Clone(5), undefined, true, true);
		inventory.AddItem(global.ItemData[? "12-gauge Shell"].Clone(120), undefined, true, true);
		
		inventory.AddItem(global.ItemData[? "9mm Bullet"].Clone(120), undefined, true, true);
		inventory.AddItem(global.ItemData[? "9mm Bullet"].Clone(120), undefined, true, true);
		inventory.AddItem(global.ItemData[? "7.62 Bullet"].Clone(120), undefined, true, true);
		inventory.AddItem(global.ItemData[? "7.62 Tracer Bullet"].Clone(120), undefined, true, true);

		inventory.AddItem(global.ItemData[? "Money"].Clone(100), undefined, true, true);
		inventory.AddItem(global.ItemData[? "Water Bottle"].Clone(), undefined, true, true);
		inventory.AddItem(global.ItemData[? "Bandage"].Clone(), undefined, true, true);
		inventory.AddItem(global.ItemData[? "First Aid Kit"].Clone(), undefined, true, true);
	
		inventory.AddItem(global.ItemData[? "Canned Meat"].Clone(), undefined, true, true);
		inventory.AddItem(global.ItemData[? "Snickers Bar"].Clone(), undefined, true, true);
	
		inventory.AddItem(global.ItemData[? "Gas Can"].Clone(), undefined, true, true);
	}
}