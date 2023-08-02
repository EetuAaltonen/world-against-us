if (initHUDValues)
{
	if (instance_exists(global.ObjPlayer))
	{
		if (!is_undefined(global.ObjPlayer.character))
		{
			hudElementFullness.SetValueReference(global.ObjPlayer.character.fullness);
			hudElementHydration.SetValueReference(global.ObjPlayer.character.hydration);
			hudElementEnergy.SetValueReference(global.ObjPlayer.character.energy);
			
			hudElementAmmo.SetWeaponReference(global.ObjPlayer.weapon);
			hudElementAmmo.initAmmo = true;
			
			initHUDValues = false;
		}
	}
}