function GetCharacterActionInterrupts(_instanceRef)
{
	if (!instance_exists(_instanceRef)) return;
	var characterRef = _instanceRef.character;
	if (is_undefined(characterRef)) return;
	var actionHandlerRef = characterRef.action_handler;
	
	// ACTIONS THAT DON'T INTERUPT OTHER ACTIONS
	if (is_undefined(actionHandlerRef.active_action))
	{
		if (!actionHandlerRef.IsActionInCooldown(CHARACTER_ACTION.SHOOT))
		{
			var primaryWeaponRef = _instanceRef.character.gear.GetItemBySlot(_instanceRef.character.gear.primary_weapon);
			if (!is_undefined(primaryWeaponRef))
			{
				var firingModeIndex = primaryWeaponRef.metadata.firing_mode_index;
				var firingMode = primaryWeaponRef.metadata.firing_modes[firingModeIndex];
				if (firingMode == FIRING_MODE_BURST)
				{
					if (primaryWeaponRef.metadata.burst_firing_index > 0)
					{
						var actionResult = CharacterActionWeaponGunShoot(self, mouse_x, mouse_y);
						if (actionResult != CHARACTER_ACTION_RESULT_WEAPON_GUN_RELOAD.RELOADED)
						{
							// ACTION FAILED
							primaryWeaponRef.metadata.burst_firing_index = 0;
						}
					}
				}
			}
		}
	}
}