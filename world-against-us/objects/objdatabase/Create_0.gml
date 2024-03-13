// ITEM DATABASE
itemDatabase = new DatabaseItem();
var jsonItemStruct = ReadJSONFile("item_data.json") ?? EMPTY_STRUCT;
ParseJSONStructToMap(itemDatabase.itemData, jsonItemStruct[$ "item_data"] ?? undefined, "name", ParseJSONStructToDatabaseItem);

// QUEST DATABASE
questData = ds_map_create();
var jsonQuestStruct = ReadJSONFile("quest_data.json") ?? EMPTY_STRUCT;
ParseJSONStructToMap(questData, jsonQuestStruct[$ "quest_data"] ?? undefined, "quest_id", ParseJSONStructToDatabaseQuest);

// DIALOGUE DATABASE
dialogueData = ds_map_create();
// READ ALL LOOT TABLE JSON FILES
// TODO: Move this to script
try {
	var directoryPath = string("{0}{1}", working_directory, "\dialogues");
	if directory_exists(directoryPath)
	{
		var filePath = string("{0}{1}", working_directory, "/dialogues/");
		var fileName = file_find_first(filePath + "*dialogue.twee", fa_none);

		while (fileName != EMPTY_STRING)
		{
			var dialogueStoryTitle = undefined;
			var storyDialogues = ds_map_create();
			
		    var dialogueFile = file_text_open_read(string("{0}{1}", filePath, fileName));
			while (!file_text_eof(dialogueFile))
			{
			    var textLine = file_text_readln(dialogueFile);
				// REPLACE WINDOWS UTF8 ENCODING WITH UTF8 UNIX
				// TODO: Replace every incompatible UTF8 encodings
				var parsedTextLine = string_replace_all(textLine, STRING_LINE_BREAK_WINDOWS, STRING_LINE_BREAK);
				if (parsedTextLine != STRING_LINE_BREAK)
				{
					switch (parsedTextLine)
					{
						case ":: StoryTitle\n":
						{
							// FETCH DIALOGUE ID
							dialogueStoryTitle = string_replace(file_text_readln(dialogueFile), STRING_LINE_BREAK, EMPTY_STRING);
						} break;
						case ":: StoryData\n":
						{
							// SKIP WHOLE STORY DATA
							while (parsedTextLine != "}\n")
							{
								parsedTextLine = file_text_readln(dialogueFile);
							}
						} break;
						default:
						{
							if (!is_undefined(dialogueStoryTitle))
							{
								if (string_starts_with(parsedTextLine, "::"))
								{
									var textLineParts = string_split(parsedTextLine, " {", true, 1);
									var dialogueId = string_replace(array_first(textLineParts), ":: ", EMPTY_STRING);
									var dialogue = new Dialogue(dialogueStoryTitle, dialogueId);
								
									parsedTextLine = file_text_readln(dialogueFile);
									while (!string_starts_with(parsedTextLine,";;end"))
									{
										if (string_starts_with(parsedTextLine, "[["))
										{
											parsedTextLine = string_replace(string_replace(parsedTextLine, "[[", EMPTY_STRING), "]]\n", EMPTY_STRING);
											var dialogueOptionParts = string_split(parsedTextLine, "->", true, 1);
											dialogue.AddDialogueOption(
												new DialogueOption(
													dialogueStoryTitle,
													dialogue.dialogue_index,
													array_first(dialogueOptionParts),
													array_last(dialogueOptionParts)
												)
											);
										} else if (string_starts_with(parsedTextLine, ";;character"))
										{
											var characterParts = string_split(parsedTextLine, ":", true, 1);
											var characterIcon = string_replace(array_last(characterParts), STRING_LINE_BREAK, EMPTY_STRING);
											var characterIconIndex = asset_get_index(characterIcon);
											if (characterIconIndex != -1)
											{
												dialogue.character_icon = characterIconIndex;
											} else {
												throw (string("Missing sprite for character icon '{0}'", characterIcon));
											}
										} else if (string_starts_with(parsedTextLine, ";;trigger"))
										{
											var triggerParts = string_split(parsedTextLine, ":", true, 1);
											var triggerFunctionName = string_replace(array_last(triggerParts), STRING_LINE_BREAK, EMPTY_STRING);
											var triggerFunctioIndex = asset_get_index(triggerFunctionName);
											if (triggerFunctioIndex != -1)
											{
												if (script_exists(triggerFunctioIndex))
												{
													dialogue.trigger_function = triggerFunctioIndex;
												} else {
													throw (string("Missing script for trigger function '{0}' in {1}", triggerFunctionName, fileName));
												}
											} else {
												throw (string("Missing script for trigger function '{0}' in {1}", triggerFunctionName, fileName));
											}
										} else if (string_starts_with(parsedTextLine, "::"))
										{
											throw (string("Missing ';;end' flag in {0}->{1} in {2}", dialogueStoryTitle, dialogue.dialogue_index, fileName));
										} else {
											dialogue.AddChatLine(parsedTextLine);
										}
										parsedTextLine = file_text_readln(dialogueFile);
									}
									ds_map_add(storyDialogues, dialogue.dialogue_index, dialogue);
								}
							} else {
								throw (string("Missing dialogue story title in {0}", fileName));
							}
						}
					}
				}
			}
			file_text_close(dialogueFile);
			ds_map_add(dialogueData, dialogueStoryTitle, storyDialogues);
		    fileName = file_find_next();
		}
		file_find_close();
	}
} catch (error)
{
	global.ConsoleHandlerRef.AddConsoleLog(CONSOLE_LOG_TYPE.ERROR, error);
}

// LOOT TABLE DATABASE
lootTableData = ds_map_create();
// READ ALL LOOT TABLE JSON FILES
// TODO: Move this to script
try {
	var directoryPath = string("{0}{1}", working_directory, "\loot_tables");
	if directory_exists(directoryPath)
	{
		var filePath = string("{0}{1}", working_directory, "/loot_tables/");
		var fileName = file_find_first(filePath + "*loot_table.json", fa_none);

		while (fileName != EMPTY_STRING)
		{
		    var jsonLootTableStruct = ReadJSONFile(string("{0}{1}", "/loot_tables/", fileName)) ?? EMPTY_STRUCT;
			var lootTableTag = jsonLootTableStruct[$ "tag"];
			var lootTablePoolData = ParseJSONStructToArray(jsonLootTableStruct[$ "pools"] ?? undefined, ParseJSONStructToDatabaseLootTablePool);
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
	show_message(error);
}

// BLUEPRINT DATABASE
blueprintData = ds_map_create();
// READ ALL BLUEPRINT JSON FILES
// TODO: Move this to script
try {
	var directoryPath = string("{0}{1}", working_directory, "\construction_blueprints");
	if directory_exists(directoryPath)
	{
		var filePath = string("{0}{1}", working_directory, "/construction_blueprints/");
		var fileName = file_find_first(filePath + "*blueprint.json", fa_none);

		while (fileName != EMPTY_STRING)
		{
		    var jsonblueprintStruct = ReadJSONFile(string("{0}{1}", "/construction_blueprints/", fileName)) ?? EMPTY_STRUCT;
			var blueprintTag = jsonblueprintStruct[$ "tag"];
			var blueprintMaterials = ParseJSONStructToArray(jsonblueprintStruct[$ "blueprints"] ?? undefined, ParseJSONStructToDatabaseConstructionBlueprint);

			ds_map_add(blueprintData, blueprintTag, blueprintMaterials);
		    fileName = file_find_next();
		}
		file_find_close();
	}
} catch (error)
{
	show_debug_message(error);
	show_message(error);
}

// OBJECT EXAMINE DATABASE
objectExamineData = ds_map_create();
var jsonObjectExamineStruct = ReadJSONFile("object_examine_data.json") ?? EMPTY_STRUCT;
ParseJSONStructToMap(objectExamineData, jsonObjectExamineStruct[$ "object_examine_data"] ?? undefined, "object_name", ParseJSONStructToDatabaseObjectExamine);

// WORLD MAP DATABASE
worldMapLocationData = ds_map_create();
var jsonMapStruct = ReadJSONFile("/map_data/world_map_location_data.json") ?? EMPTY_STRUCT;
ParseJSONStructToMap(worldMapLocationData, jsonMapStruct[$ "world_map_location_data"] ?? undefined, "room_index", ParseJSONStructToDatabaseWorldMapLocationData);

// MAP ICON STYLE DATABASE
mapIconStyleData = ds_map_create();
var jsonMapIconStyleStruct = ReadJSONFile("/map_data/map_icon_style_data.json") ?? EMPTY_STRUCT;
ParseJSONStructToMap(mapIconStyleData, jsonMapIconStyleStruct[$ "map_icon_style_data"] ?? undefined, "object_name", ParseJSONStructToDatabaseMapIconStyleData);