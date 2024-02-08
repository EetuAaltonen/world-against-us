/// @description Custom RoomStartEvent
var character = playerDataHandler.character;
if (!is_undefined(character))
{
	// RESTORE PLAYER NORMAL STATE
	if (character.IsInvulnerableState())
	{
		if (room_get_name(room) == ROOM_INDEX_CAMP)
		{
			// DELETE ALL ITEMS AFTER BEING ROBBED
			// AND SAVE LOCAL GAME
			if (character.is_robbed)
			{
				// DELETE ALL ITEMS
				global.PlayerBackpack.ClearAllItems();
				
				character.RestoreState();
				
				// SAVE 
				global.GameSaveHandlerRef.SaveGame();
			}
		}
		character.RestoreState();
	}
}