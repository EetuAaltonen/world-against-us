// ITEM DATA
var jsonItemStruct = ReadJSONFile("item_data.json") ?? {};
itemData = ParseJSONStructArrayToMap(jsonItemStruct[$ "item_data"], "name", ParseJSONStructToDatabaseItem);

// BULLET DATA
bulletData = ds_map_create();
ds_map_add(bulletData, 7.62, spr762Bullet);
ds_map_add(bulletData, 9, spr9mmBullet);

// QUEST DATA
var jsonQuestStruct = ReadJSONFile("quest_data.json") ?? {};
questData = ParseJSONStructArrayToMap(jsonQuestStruct[$ "quest_data"], "quest_id", ParseJSONStructToDatabaseQuest);