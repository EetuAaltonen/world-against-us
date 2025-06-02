function CollisionBody(_collisionBodyType) constructor
{
	collision_body_type = _collisionBodyType;
	
	total_hitpoints = 0;
	hitpoints = 0;
	body_parts = ds_map_create();
	iframe_timer = new Timer(FRAME_TIME * 2);
	state = COLLISION_BODY_STATE.ALIVE;
	// TRIGGERS HP UPDATE ON NEXT FRAME
	is_condition_modified = true;
	
	InitCollisionBody();
	
	static InitCollisionBody = function()
	{
		InitCollisionBodyParts(body_parts, collision_body_type);
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
		if (state == COLLISION_BODY_STATE.ALIVE)
		{
			if (is_condition_modified)
			{
				CalculateHitpoints();
				is_condition_modified = false;
			}
			
			if (hitpoints <= 0)
			{
				state = COLLISION_BODY_STATE.ON_DEAD;
			}
			
			// UPDATE IFRAMES
			iframe_timer.Update();
		} else if (state == COLLISION_BODY_STATE.ON_DEAD)
		{
			state = COLLISION_BODY_STATE.DEAD;
		}
	}
	
	static CalculateHitpoints = function()
	{
		var calculatedHitpoints = 0;
		var calculatedTotalHitpoints = 0;
		var bodyPartIndices = ds_map_keys_to_array(body_parts);
		var bodyPartCount = array_length(bodyPartIndices);
		for (var i = 0; i < bodyPartCount; i++)
		{
			var bodyPart = body_parts[? bodyPartIndices[@ i]];
			
			calculatedTotalHitpoints += bodyPart.total_hitpoints;
			calculatedHitpoints += bodyPart.hitpoints;
			if (bodyPart.is_vital_part && bodyPart.hitpoints <= 0)
			{
				state = COLLISION_BODY_STATE.ON_DEAD;
			}
		}
		
		total_hitpoints = calculatedTotalHitpoints;
		hitpoints = calculatedHitpoints;
		if (hitpoints <= 0)
		{
			state = COLLISION_BODY_STATE.ON_DEAD;
		}
	}
	
	static TakeDamage = function(_damage, _targetBodyPartType = undefined)
	{
		var targetBodyPart = undefined;
		if (!is_undefined(_targetBodyPartType))
		{
			targetBodyPart = body_parts[? _targetBodyPartType];
		} else {
			if (collision_body_type == COLLISION_BODY_TYPE.Full_sprite)
			{
				targetBodyPart = body_parts[? COLLISION_BODY_PART_TYPE.StaticBody];
			} else {
				// RANDOMIZE TARGET BODY PART
				var shuffledBodyParts = GetBodyPartsByCondition(1, false, true);
				if (array_length(shuffledBodyParts) > 0)
				{
					targetBodyPart = shuffledBodyParts[@ 0];
				} else {
					CalculateHitpoints();
					throw(string("Unable to take more damage hp: {0}", hitpoints));
				}
			}
		}
			 
		if (!is_undefined(targetBodyPart))
		{
			var takenDamage = targetBodyPart.TakeDamage(_damage);
			_damage -= takenDamage;
		} else {
			throw(string("Invalid target body part type '{0}'", _targetBodyPartType));
		}
		
		// IFRAMES AFTER HIT
		iframe_timer.StartTimer();
		
		// SET HEALTH MODIFIED
		is_condition_modified = true;
	}
	
	static RestoreHealth = function(_amount, _targetBodyPartType = undefined)
	{
		// TODO: Fix this function
	}
	
	static GetBodyPartsByCondition = function(_minimumCondition, _sort = false, _shuffle = false)
	{
		var bodyParts = [];
		var bodyPartIndices = ds_map_keys_to_array(body_parts);
		var bodyPartCount = array_length(bodyPartIndices);
		for (var i = 0; i < bodyPartCount; i++)
		{
			var bodyPart = body_parts[? bodyPartIndices[@ i]];
			if (!is_undefined(bodyPart))
			{
				if (bodyPart.hitpoints >= _minimumCondition)
				{
					array_push(bodyParts, bodyPart)
				}
			}
		}
		if (_sort)
		{
			array_sort(bodyParts, function(elm1, elm2)
			{
				return elm1.hitpoints - elm2.hitpoints;
			});
		}
		
		if (_shuffle)
		{
			bodyParts = array_shuffle(bodyParts);
		}
		return bodyParts;
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
					_instanceRef.y - (spriteSize.h * 0.5) - (_instanceRef.sprite_yoffset * 0.5) - _instanceRef.z,
					_instanceRef.x + (spriteSize.w * 0.5),
					_instanceRef.y + (spriteSize.h * 0.5) - (_instanceRef.sprite_yoffset * 0.5) - _instanceRef.z,
					outlineColor, outlineColor, outlineColor, outlineColor, true
				);
			} break;
			default: {
				draw_rectangle_color(
					_instanceRef.x - (spriteSize.w * 0.5),
					_instanceRef.y - (spriteSize.h * 0.5) - (_instanceRef.sprite_yoffset * 0.5) - _instanceRef.z,
					_instanceRef.x + (spriteSize.w * 0.5),
					_instanceRef.y + (spriteSize.h * 0.5) - (_instanceRef.sprite_yoffset * 0.5) - _instanceRef.z,
					outlineColor, outlineColor, outlineColor, outlineColor, true
				);
				
				var collisionBodyTopLeftPos = new Vector2(
					_instanceRef.x - (spriteSize.w * 0.5),
					_instanceRef.y - (spriteSize.h * 0.5) - (_instanceRef.sprite_yoffset * 0.5) - _instanceRef.z
				);
				var bodyPartIndices = ds_map_keys_to_array(body_parts);
				var bodyPartCount = array_length(bodyPartIndices);
				for (var i = 0; i < bodyPartCount; i++)
				{
					var bodyPart = body_parts[? bodyPartIndices[@ i]];
					if (!is_undefined(bodyPart))
					{
						if (bodyPart.hitpoints <= 0)
						{
							outlineColor = c_red;
						} else if (bodyPart.hitpoints <= (bodyPart.total_hitpoints * 0.25))
						{
							outlineColor = c_orange;
						} else if (bodyPart.hitpoints <= (bodyPart.total_hitpoints * 0.50))
						{
							outlineColor = c_yellow;
						} else if (bodyPart.hitpoints <= (bodyPart.total_hitpoints * 0.75))
						{
							outlineColor = c_lime;
						} else if (bodyPart.hitpoints > (bodyPart.total_hitpoints * 0.75))
						{
							outlineColor = c_green;
						}
						
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
}