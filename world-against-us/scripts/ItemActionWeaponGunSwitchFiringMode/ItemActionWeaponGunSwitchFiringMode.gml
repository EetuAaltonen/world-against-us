function ItemActionWeaponGunSwitchFiringMode(_gunItemRef)
{
	var metadata = _gunItemRef.metadata;
	metadata.firing_mode_index++;
	var firing_modes_count = array_length(metadata.firing_modes);
	if (metadata.firing_mode_index >= firing_modes_count) metadata.firing_mode_index = 0;
}