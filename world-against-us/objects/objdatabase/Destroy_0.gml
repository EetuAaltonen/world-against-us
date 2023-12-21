itemDatabase.OnDestroy();

DestroyDSMapAndDeleteValues(questData);
questData = undefined;

DestroyDSMapAndDeleteValues(dialogueData, ds_type_map);
dialogueData = undefined;

DestroyDSMapAndDeleteValues(lootTableData);
lootTableData = undefined;

DestroyDSMapAndDeleteValues(blueprintData);
blueprintData = undefined;

DestroyDSMapAndDeleteValues(objectExamineData);
objectExamineData = undefined;

DestroyDSMapAndDeleteValues(worldMapLocationData);
worldMapLocationData = undefined;

DestroyDSMapAndDeleteValues(mapIconStyleData);
mapIconStyleData = undefined;