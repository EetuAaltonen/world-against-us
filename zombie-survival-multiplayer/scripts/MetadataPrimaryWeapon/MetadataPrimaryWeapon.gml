function MetadataPrimaryWeapon(_caliber, _fire_rate, _range, _recoil, _attachment_slots, _barrel_pos) : Metadata() constructor
{
    caliber = _caliber;
    fire_rate = _fire_rate;
    range = _range;
    recoil = _recoil;
    attachment_slots = _attachment_slots;
	barrel_pos = new Vector2(_barrel_pos.X, _barrel_pos.Y);
	magazine = undefined;
}