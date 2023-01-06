// ITEM DATA
var jsonStruct = ReadJSONFile("item_data.json") ?? {};
itemData = ParseStructArrayToMap(jsonStruct[$ "item_data"], "name", ParseJSONStructToDatabaseItem);

// BULLET DATA
bulletData = ds_map_create();
ds_map_add(bulletData, 7.62, spr762Bullet);
ds_map_add(bulletData, 9, spr9mmBullet);

// QUEST DATA
questData = ReadDataFromJSONFile("quest_data.json", "quest_data", FormatDataMapFromFile, "quest_id", JSONStructToQuest);