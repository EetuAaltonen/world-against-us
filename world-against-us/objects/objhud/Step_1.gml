if (initHUDValues)
{
	if (instance_exists(global.InstancePlayer))
	{
		if (!is_undefined(global.InstancePlayer.character))
		{
			hudElementFullness.SetValueReference(global.InstancePlayer.character.fullness);
			hudElementHydration.SetValueReference(global.InstancePlayer.character.hydration);
			hudElementEnergy.SetValueReference(global.InstancePlayer.character.energy);
			
			// TODO: Fix weapon logic
			/*
			hudElementAmmo.SetInstanceReference(global.InstancePlayer.weapon);
			hudElementAmmo.initAmmo = true;
			*/
			initHUDValues = false;
		}
	}
}