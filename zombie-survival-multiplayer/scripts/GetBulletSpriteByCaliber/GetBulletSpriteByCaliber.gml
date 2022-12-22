function GetBulletSpriteByCaliber(_caliber)
{
	var bulletSprite = undefined;
	
	if (!is_undefined(global.BulletData))
	{
		// GET VALUE BY KEY OR THE FIRST DEFAULT ELEMENT IF UNDEFINED
		bulletSprite = global.BulletData[? _caliber] ?? global.BulletData[? ds_map_find_first(global.BulletData)];
	}
	return bulletSprite;
}