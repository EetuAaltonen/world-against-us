// ITEM DATA
itemData = ReadDataFromJSONFile("item_data.json", "item_data", FormatDataMapFromFile, "name", JSONStructToItem);

// BULLET DATA
bulletData = ds_map_create();
ds_map_add(bulletData, 7.62, spr762Bullet);
ds_map_add(bulletData, 9, spr9mmBullet);

// QUEST DATA
questData = ReadDataFromJSONFile("quest_data.json", "quest_data", FormatDataMapFromFile, "quest_id", JSONStructToQuest);