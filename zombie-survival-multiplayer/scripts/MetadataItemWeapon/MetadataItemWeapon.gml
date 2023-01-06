function MetadataItemWeapon(_caliber, _fire_rate, _range, _recoil, _attachment_slots, _barrel_pos) : Metadata() constructor
{
    caliber = _caliber;
    fire_rate = _fire_rate;
    range = _range;
    recoil = _recoil;
    attachment_slots = _attachment_slots;
	barrel_pos = new Vector2(_barrel_pos.X, _barrel_pos.Y);
	magazine = undefined;
	
	static ToJSONStruct = function()
	{
		var formatBarrelPos = barrel_pos.ToJSONStruct();
		var formatMagazine = !is_undefined(magazine) ? magazine.ToJSONStruct() : magazine;
		return {
			caliber: caliber,
			fire_rate: fire_rate,
			range: range,
			recoil: recoil,
			attachment_slots: attachment_slots,
			barrel_pos: formatBarrelPos,
			magazine: formatMagazine,
		}
	}
}