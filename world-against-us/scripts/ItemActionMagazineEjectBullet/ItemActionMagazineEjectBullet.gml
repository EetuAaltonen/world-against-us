function ItemActionMagazineEjectBullet(_magazineItemRef)
{
	var ejectedBullet = undefined;
	var bulletsRef = _magazineItemRef.metadata.bullets;
	if (array_length(bulletsRef) <= 0) return ejectedBullet;
	var bulletName = array_pop(bulletsRef);
	if (is_undefined(bulletName)) return ejectedBullet;
	
	ejectedBullet = global.ItemDatabase.GetItemByName(bulletName);
	return ejectedBullet;
}