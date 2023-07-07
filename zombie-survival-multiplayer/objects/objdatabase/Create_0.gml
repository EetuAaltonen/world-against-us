// ITEM DATA
var jsonItemStruct = ReadJSONFile("item_data.json") ?? {};
itemData = ParseJSONStructArrayToMap(jsonItemStruct[$ "item_data"], "name", ParseJSONStructToDatabaseItem);

// BULLET DATA
bulletData = ds_map_create();
ds_map_add(bulletData, "7.62 Bullet", spr762BulletProjectile);
ds_map_add(bulletData, "7.62 Tracer Bullet", spr762TracerBulletProjectile);

// QUEST DATA
var jsonQuestStruct = ReadJSONFile("quest_data.json") ?? {};
questData = ParseJSONStructArrayToMap(jsonQuestStruct[$ "quest_data"], "quest_id", ParseJSONStructToDatabaseQuest);

// DIALOGUE DATA
dialogueData = ds_map_create();
// READ ALL LOOT TABLE JSON FILES
// TODO: Move this to script
try {
	var diractoryPath = string("{0}{1}", working_directory, "\dialogues");
	if directory_exists(diractoryPath)
	{
		var filePath = string("{0}{1}", working_directory, "/dialogues/");
		var fileName = file_find_first(filePath + "*dialogue.twee", fa_none);

		while (fileName != "")
		{
			var dialogueStoryTitle = undefined;
			var storyDialogues = ds_map_create();
			
		    var dialogueFile = file_text_open_read(string("{0}{1}", filePath, fileName));
			while (!file_text_eof(dialogueFile))
			{
			    var textLine = file_text_readln(dialogueFile);
				if (textLine != "\n")
				{
					switch (textLine)
					{
						case ":: StoryTitle\n":
						{
							// FETCH DIALOGUE ID
							dialogueStoryTitle = string_replace(file_text_readln(dialogueFile), "\n", "");
						} break;
						case ":: StoryData\n":
						{
							// SKIP WHOLE STORY DATA
							while (textLine != "}\n")
							{
								textLine = file_text_readln(dialogueFile);
							}
						} break;
						default:
						{
							if (!is_undefined(dialogueStoryTitle))
							{
								if (string_starts_with(textLine, "::"))
								{
									var textLineParts = string_split(textLine, " {", true, 1);
									var dialogueId = string_replace(array_first(textLineParts), ":: ", "");
									var dialogue = new Dialogue(dialogueStoryTitle, dialogueId);
								
									textLine = file_text_readln(dialogueFile);
									while (!string_starts_with(textLine,";;end"))
									{
										if (string_starts_with(textLine, "[["))
										{
											textLine = string_replace(string_replace(textLine, "[[", ""), "]]\n", "");
											var dialogueOptionParts = string_split(textLine, "->", true, 1);
											dialogue.AddDialogueOption(
												new DialogueOption(
													dialogueStoryTitle,
													dialogue.dialogue_index,
													array_first(dialogueOptionParts),
													array_last(dialogueOptionParts)
												)
											);
										} else if (string_starts_with(textLine, ";;character"))
										{
											var characterParts = string_split(textLine, ":", true, 1);
											var characterIcon = string_replace(array_last(characterParts), "\n", "");
											var characterIconIndex = asset_get_index(characterIcon);
											if (characterIconIndex != -1)
											{
												dialogue.character_icon = characterIconIndex;
											} else {
												throw (string("Missing sprite for character icon '{0}'", characterIcon));
											}
										} else if (string_starts_with(textLine, "::"))
										{
											throw (string("Missing ';;end' flag in {0}->{1}", dialogueStoryTitle, dialogue.dialogue_index));
										} else {
											dialogue.AddChatLine(textLine);
										}
										textLine = file_text_readln(dialogueFile);
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
			ds_map_add_map(dialogueData, dialogueStoryTitle, storyDialogues);
		    fileName = file_find_next();
		}
		file_find_close();
	}
} catch (error)
{
	show_debug_message(error);
}

// LOOT TABLE DATA
lootTableData = ds_map_create();
// READ ALL LOOT TABLE JSON FILES
// TODO: Move this to script
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