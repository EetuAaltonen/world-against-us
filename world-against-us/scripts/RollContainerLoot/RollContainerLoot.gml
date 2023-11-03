function RollContainerLoot(_lootTableTag, _inventory)
{
	var lootTable = global.LootTableData[? _lootTableTag];
	var lootData = lootTable.RollLoot();
	var lootCount = array_length(lootData);
	for (var i = 0; i < lootCount; i++)
	{
		var lootEntry = lootData[@ i];
		var item = global.ItemDatabase.GetItemByName(lootEntry.name);
		item.is_known = false;
		repeat(lootEntry.count)
		{
			var lootItemGridIndex = _inventory.AddItem(item, undefined, false, item.is_known);
			if (is_undefined(lootItemGridIndex)) break;
		}
	}
}