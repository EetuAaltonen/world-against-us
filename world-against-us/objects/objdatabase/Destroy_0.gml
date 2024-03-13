// ITEM DATABASE
itemDatabase.OnDestroy();
itemDatabase = undefined;

// QUEST DATA
DestroyDSMapAndDeleteValues(questData);
questData = undefined;

// DIALOGUE DATABASE
DestroyDSMapAndDeleteValues(dialogueData, ds_type_map);
dialogueData = undefined;

// LOOT TABLE DATABASE
DestroyDSMapAndDeleteValues(lootTableData);
lootTableData = undefined;

// BLUEPRINT DATABASE
DestroyDSMapAndDeleteValues(blueprintData);
blueprintData = undefined;

// OBJECT EXAMINE DATABASE
DestroyDSMapAndDeleteValues(objectExamineData);
objectExamineData = undefined;

// WORLD MAP DATABASE
DestroyDSMapAndDeleteValues(worldMapLocationData);
worldMapLocationData = undefined;

// MAP ICON STYLE DATABASE
DestroyDSMapAndDeleteValues(mapIconStyleData);
mapIconStyleData = undefined;