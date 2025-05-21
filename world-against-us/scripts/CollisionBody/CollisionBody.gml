function CollisionBody(_collisionBodyType) constructor
{
	collision_body_type = _collisionBodyType;
	
	total_hitpoints = 0;
	hitpoints = 0;
	body_parts = ds_map_create();
	iframe_timer = new Timer(FRAME_TIME * 2);
	is_dead = false;
	
	InitCollisionBody();
	
	static InitCollisionBody = function()
	{
		InitCollisionBodyParts(body_parts, collision_body_type);
		CalculateHitpoints();
	}
	
	static OnDestroy = function()
	{
		DestroyDSMapAndDeleteValues(body_parts);
		body_parts = undefined;
		
		iframe_timer.OnDestroy();
		iframe_timer = undefined;
	}
	
	static Update = function()
	{
		if (!is_dead)
		{
			if (hitpoints <= 0)
			{
				is_dead = true;
			}
		}
		
		// UPDATE IFRAMES
		iframe_timer.Update();
	}
	
	static Draw = function(_instanceRef)
	{
		var outlineColor = iframe_timer.IsTimerTriggered() ? c_white : c_orange;
		var spriteSize = new Size(_instanceRef.sprite_width, _instanceRef.sprite_height);
		switch (collision_body_type)
		{
			case COLLISION_BODY_TYPE.Full_sprite: {
				draw_rectangle_color(
					_instanceRef.x - (spriteSize.w * 0.5),
					_instanceRef.y - (spriteSize.h * 0.5) - (_instanceRef.sprite_yoffset * 0.5) + _instanceRef.z,
					_instanceRef.x + (spriteSize.w * 0.5),
					_instanceRef.y + (spriteSize.h * 0.5) - (_instanceRef.sprite_yoffset * 0.5) + _instanceRef.z,
					outlineColor, outlineColor, outlineColor, outlineColor, true
				);
			} break;
			default: {
				draw_rectangle_color(
					_instanceRef.x - (spriteSize.w * 0.5),
					_instanceRef.y - (spriteSize.h * 0.5) - (_instanceRef.sprite_yoffset * 0.5) + _instanceRef.z,
					_instanceRef.x + (spriteSize.w * 0.5),
					_instanceRef.y + (spriteSize.h * 0.5) - (_instanceRef.sprite_yoffset * 0.5) + _instanceRef.z,
					outlineColor, outlineColor, outlineColor, outlineColor, true
				);
				
				var collisionBodyTopLeftPos = new Vector2(
					_instanceRef.x - (spriteSize.w * 0.5),
					_instanceRef.y - (spriteSize.h * 0.5) - (_instanceRef.sprite_yoffset * 0.5) + _instanceRef.z
				);
				outlineColor = c_red;
				var bodyPartIndices = ds_map_keys_to_array(body_parts);
				var bodyPartCount = array_length(bodyPartIndices);
				for (var i = 0; i < bodyPartCount; i++)
				{
					var bodyPart = body_parts[? bodyPartIndices[@ i]];
					if (!is_undefined(bodyPart))
					{
						draw_rectangle_color(
							collisionBodyTopLeftPos.X + (spriteSize.w * bodyPart.bounding_box.top_left_point.X),
							collisionBodyTopLeftPos.Y + (spriteSize.h * bodyPart.bounding_box.top_left_point.Y),
							collisionBodyTopLeftPos.X + (spriteSize.w * bodyPart.bounding_box.bottom_right_point.X),
							collisionBodyTopLeftPos.Y + (spriteSize.h * bodyPart.bounding_box.bottom_right_point.Y),
							outlineColor, outlineColor, outlineColor, outlineColor, true
						)
					}
				}
			}
		}
	}
	
	static CalculateHitpoints = function()
	{
		var bodyPartsTotalHitpoints = 0;
		var bodyPartsHitpoints = 0;
		var bodyPartIndices = ds_map_keys_to_array(body_parts);
		var bodyPartCount = array_length(bodyPartIndices);
		
		if (bodyPartCount > 0)
		{
			for (var i = 0; i < bodyPartCount; i++)
			{
				var bodyPart = body_parts[? bodyPartIndices[@ i]];
			
				bodyPartsTotalHitpoints += bodyPart.total_hitpoints;
				bodyPartsHitpoints += bodyPart.hitpoints;
				
				if (bodyPart.is_vital_part && bodyPart.hitpoints <= 0)
				{
					is_dead = true;
				}
			}
		}
		total_hitpoints = bodyPartsTotalHitpoints;
		hitpoints = bodyPartsHitpoints;
	}
	
	static TakeDamage = function(_damage, _targetBodyPartType = undefined)
	{
		var targetBodyPartIndex = _targetBodyPartType || COLLISION_BODY_PART_TYPE.StaticBody;
		var targetBodyPart = body_parts[? targetBodyPartIndex];
		if (!is_undefined(targetBodyPart)) {
			targetBodyPart.TakeDamage(_damage);
			CalculateHitpoints();
		} else {
			// TODO: Handle when target bodypart is undefined
		}
		
		// IFRAMES AFTER HIT
		iframe_timer.StartTimer();
	}
	
	static RestoreHealth = function(_amount, _targetBodyPartType = undefined)
	{
		var targetBodyPartIndex = _targetBodyPartType || COLLISION_BODY_PART_TYPE.StaticBody;
		var targetBodyPart = body_parts[? targetBodyPartIndex];
		if (!is_undefined(targetBodyPart)) {
			targetBodyPart.RestoreHealth(_amount);
			CalculateHitpoints();
		} else {
			// TODO: Handle when target bodypart is undefined
		}
	}
}