// ITEM DATABASE
ReleaseVariableFromMemory(itemDatabase);
itemDatabase = undefined;

// QUEST DATA
ReleaseVariableFromMemory(questData, ds_type_map);
questData = undefined;

// DIALOGUE DATABASE
ReleaseVariableFromMemory(dialogueData, ds_type_map);
dialogueData = undefined;

// LOOT TABLE DATABASE
ReleaseVariableFromMemory(lootTableData, ds_type_map);
lootTableData = undefined;

// BLUEPRINT DATABASE
ReleaseVariableFromMemory(blueprintData, ds_type_map);
blueprintData = undefined;

// OBJECT EXAMINE DATABASE
ReleaseVariableFromMemory(objectExamineData, ds_type_map);
objectExamineData = undefined;

// WORLD MAP DATABASE
ReleaseVariableFromMemory(worldMapLocationData, ds_type_map);
worldMapLocationData = undefined;

// MAP ICON STYLE DATABASE
ReleaseVariableFromMemory(mapIconStyleData, ds_type_map);
mapIconStyleData = undefined;