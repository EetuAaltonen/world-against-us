image_xscale = 0.75;
image_yscale = image_xscale;

interactionRange = 200;

insideInteractionRange = false;

loot = new Inventory(INVENTORY_TYPE.LootContainer);

loot.AddItem(new Item(
	"Army Helmet",
	sprArmyHelmet,
	new Size(2, 2),
	2,
	"An army helmet to protect the head"
));
loot.AddItem(new Item(
	"Water Bottle",
	sprWaterBottle,
	new Size(1, 2),
	1,
	"A bottle of clean water"
));