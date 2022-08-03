inventory = new Inventory(INVENTORY_TYPE.PlayerBackpack);
showInventory = false;

inventory.AddItem(new Item(
	"Water Bottle",
	sprWaterBottle,
	new Size(1, 2),
	1,
	"A bottle of clean water"
));

for (var i = 0; i < 3; i++)
{
	inventory.AddItem(new Item(
		"Army Helmet",
		sprArmyHelmet,
		new Size(2, 2),
		2,
		"An army helmet to protect the head"
	));
}
inventory.AddItem(new Item(
	"Water Bottle",
	sprWaterBottle,
	new Size(1, 2),
	1,
	"A bottle of clean water"
));
for (var i = 0; i < 4; i++)
{
	inventory.AddItem(new Item(
		"Army Helmet",
		sprArmyHelmet,
		new Size(2, 2),
		2,
		"An army helmet to protect the head"
	));
}
inventory.AddItem(new Item(
	"Water Bottle",
	sprWaterBottle,
	new Size(1, 2),
	1,
	"A bottle of clean water"
));
inventory.AddItem(new Item(
	"Ak-47",
	sprAk47,
	new Size(4, 2),
	8,
	"Assault rifle"
));
for (var i = 0; i < 7; i++)
{
	inventory.AddItem(new Item(
		"Army Helmet",
		sprArmyHelmet,
		new Size(2, 2),
		2,
		"An army helmet to protect the head"
	));
}
inventory.AddItem(new Item(
	"Water Bottle",
	sprWaterBottle,
	new Size(1, 2),
	1,
	"A bottle of clean water"
));
