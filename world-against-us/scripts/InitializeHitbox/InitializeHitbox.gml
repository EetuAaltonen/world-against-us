function InitializeHitbox(_instance)
{
	if (instance_exists(_instance))
	{
		if (_instance.sprite_index != -1)
		{
			var hitboxSpriteName = string("{0}_Hitbox", sprite_get_name(_instance.sprite_index));
			var hitboxSprite = asset_get_index(hitboxSpriteName);
			var hitboxInstance = instance_create_depth(_instance.x, _instance.y, _instance.depth, objHitbox);
			
			if (hitboxSprite != -1)
			{
				hitboxInstance.mask_index = hitboxSprite;
			} else {
				hitboxInstance.mask_index = (_instance.mask_index != -1) ? _instance.mask_index : _instance.sprite_index;
			}
			
			hitboxInstance.image_xscale = _instance.image_xscale;
			hitboxInstance.image_yscale = _instance.image_yscale;
			hitboxInstance.image_angle = _instance.image_angle;
			hitboxInstance.image_speed = _instance.image_speed;

			hitboxInstance.defaultMaskIndex = hitboxInstance.mask_index;
			hitboxInstance.ownerInstance = _instance;
			_instance.hitboxInstance = hitboxInstance;
		}
	}
}