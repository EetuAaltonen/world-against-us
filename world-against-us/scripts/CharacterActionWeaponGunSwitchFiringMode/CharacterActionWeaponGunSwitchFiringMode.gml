function CharacterActionWeaponGunSwitchFiringMode(_instanceRef)
{
	var actionResult = CHARACTER_ACTION_RESULT_WEAPON_GUN_SWITCH_FIRING_MODE.SWITCHED;
	var primaryWeaponRef = _instanceRef.character.gear.GetItemBySlot(_instanceRef.character.gear.primary_weapon);
	if (is_undefined(primaryWeaponRef)) return CHARACTER_ACTION_RESULT_WEAPON_GUN_SWITCH_FIRING_MODE.MISSING_GUN;

	var activeAction = new CharacterActiveAction(
		_instanceRef, CHARACTER_ACTION.SWITCH_FIRING_MODE,
		undefined, 100, 0, false, false
	);
	if (_instanceRef.character.action_handler.SetAction(activeAction, false))
	{
		ItemActionWeaponGunSwitchFiringMode(primaryWeaponRef);
	} else {
		actionResult = CHARACTER_ACTION_RESULT_WEAPON_GUN_SWITCH_FIRING_MODE.ACTION_FAILED;
	}
	return actionResult;
}