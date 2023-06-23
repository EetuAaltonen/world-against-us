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

// LOOT TABLE DATA
lootTableData = ds_map_create();

// READ ALL LOOT TABLE JSON FILES
try {
	var diractoryPath = string("{0}{1}", working_directory, "\loot_tables");
	if directory_exists(diractoryPath)
	{
		var filePath = string("{0}{1}", working_directory, "/loot_tables/");
		var fileName = file_find_first(filePath + "*loot_table.json", fa_none);

		while (fileName != "")
		{
		    var jsonLootTableStruct = ReadJSONFile(string("{0}{1}", "/loot_tables/", fileName)) ?? {};
			var lootTableTag = jsonLootTableStruct[$ "tag"];
			var lootTablePoolData = ParseJSONStructToArray(jsonLootTableStruct[$ "pools"], ParseJSONStructToDatabaseLootTablePool);
			var lootTable = new LootTable(
				lootTableTag,
				lootTablePoolData
			);

			ds_map_add(lootTableData, lootTableTag, lootTable);
		    fileName = file_find_next();
		}
		file_find_close();
	}
} catch (error)
{
	show_debug_message(error);
}

// MAP ICON STYLE DATA
var jsonMapIconStyleStruct = ReadJSONFile("map_icon_style_data.json") ?? {};
mapIconStyleData = ParseJSONStructArrayToMap(jsonMapIconStyleStruct[$ "map_icon_style_data"], "obj_index", ParseJSONStructToDatabaseMapIconStyleData);