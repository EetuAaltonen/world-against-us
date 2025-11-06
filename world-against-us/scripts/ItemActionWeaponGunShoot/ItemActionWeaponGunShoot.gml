function ItemActionWeaponGunShoot(_gunItemRef)
{
	var shotBullet = undefined;
	var magazineRef = _gunItemRef.metadata.magazine;
	if (is_undefined(magazineRef)) return shotBullet;
	shotBullet = ItemActionMagazineEjectBullet(magazineRef);
	if (!is_undefined(shotBullet))
	{
		// SET BURST MODE INDEX
		var firingMode = _gunItemRef.metadata.firing_modes[_gunItemRef.metadata.firing_mode_index];
		if (firingMode == FIRING_MODE_BURST)
		{
			if (_gunItemRef.metadata.burst_firing_index == 0)
			{
				_gunItemRef.metadata.burst_firing_index = 2; // INDEX 0-2 --> 3 SHOTS
			} else {
				_gunItemRef.metadata.burst_firing_index--;
				if (_gunItemRef.metadata.burst_firing_index < 0) _gunItemRef.metadata.burst_firing_index = 0;
			}
		}
	}
	return shotBullet;
}