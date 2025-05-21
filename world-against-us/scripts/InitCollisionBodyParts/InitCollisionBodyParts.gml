function InitCollisionBodyParts(_collisionBodyPartsRef, _collisionBodyType)
{
	switch (_collisionBodyType)
	{
		case COLLISION_BODY_TYPE.Full_sprite:
		{
			ds_map_add(
				_collisionBodyPartsRef, COLLISION_BODY_PART_TYPE.StaticBody,
				new CollisionBodyPart(
					100, true,
					new Vector2Rectangle(new Vector2(0,0), new Vector2(1,0),new Vector2(0,1), new Vector2(0,1))
				)
			);
		} break;
		case COLLISION_BODY_TYPE.Humanoid:
		{
			// HEAD
			ds_map_add(
				_collisionBodyPartsRef, COLLISION_BODY_PART_TYPE.Head,
				new CollisionBodyPart(20, true, new Vector2Rectangle(new Vector2(0.35, 0), undefined, new Vector2(0.65, 0.15), undefined)),
			);
			// THORAX
			ds_map_add(
				_collisionBodyPartsRef, COLLISION_BODY_PART_TYPE.Thorax,
				new CollisionBodyPart(40, true, new Vector2Rectangle(new Vector2(0.2, 0.15), undefined, new Vector2(0.8, 0.3), undefined)),
			);
			// LEFT ARM
			ds_map_add(
				_collisionBodyPartsRef, COLLISION_BODY_PART_TYPE.L_arm,
				new CollisionBodyPart(30, false, new Vector2Rectangle(new Vector2(0, 0.15), undefined, new Vector2(0.2, 0.6), undefined)),
			);
			// RIGHT ARM
			ds_map_add(
				_collisionBodyPartsRef, COLLISION_BODY_PART_TYPE.R_arm,
				new CollisionBodyPart(30, false, new Vector2Rectangle(new Vector2(0.8, 0.15), undefined, new Vector2(1, 0.6), undefined)),
			);
			// STOMACK
			ds_map_add(
				_collisionBodyPartsRef, COLLISION_BODY_PART_TYPE.Stomack,
				new CollisionBodyPart(40, true, new Vector2Rectangle(new Vector2(0.2, 0.3), undefined, new Vector2(0.8, 0.6), undefined)),
			);
			// LEFT LEG
			ds_map_add(
				_collisionBodyPartsRef, COLLISION_BODY_PART_TYPE.L_leg,
				new CollisionBodyPart(30, false, new Vector2Rectangle(new Vector2(0.2, 0.6), undefined, new Vector2(0.45, 1), undefined)),
			);
			// RIGHT LEG
			ds_map_add(
				_collisionBodyPartsRef, COLLISION_BODY_PART_TYPE.R_leg,
				new CollisionBodyPart(30, false, new Vector2Rectangle(new Vector2(0.55, 0.6), undefined, new Vector2(0.8, 1), undefined)),
			);
		} break;
		case COLLISION_BODY_TYPE.Zombie:
		{
			// HEAD
			ds_map_add(
				_collisionBodyPartsRef, COLLISION_BODY_PART_TYPE.Head,
				new CollisionBodyPart(10, true, new Vector2Rectangle(new Vector2(0.35, 0), undefined, new Vector2(0.65, 0.15), undefined)),
			);
			// THORAX
			ds_map_add(
				_collisionBodyPartsRef, COLLISION_BODY_PART_TYPE.Thorax,
				new CollisionBodyPart(30, true, new Vector2Rectangle(new Vector2(0.2, 0.15), undefined, new Vector2(0.8, 0.3), undefined)),
			);
			// LEFT ARM
			ds_map_add(
				_collisionBodyPartsRef, COLLISION_BODY_PART_TYPE.L_arm,
				new CollisionBodyPart(20, false, new Vector2Rectangle(new Vector2(0, 0.15), undefined, new Vector2(0.2, 0.6), undefined)),
			);
			// RIGHT ARM
			ds_map_add(
				_collisionBodyPartsRef, COLLISION_BODY_PART_TYPE.R_arm,
				new CollisionBodyPart(20, false, new Vector2Rectangle(new Vector2(0.8, 0.15), undefined, new Vector2(1, 0.6), undefined)),
			);
			// STOMACK
			ds_map_add(
				_collisionBodyPartsRef, COLLISION_BODY_PART_TYPE.Stomack,
				new CollisionBodyPart(30, true, new Vector2Rectangle(new Vector2(0.2, 0.3), undefined, new Vector2(0.8, 0.6), undefined)),
			);
			// LEFT LEG
			ds_map_add(
				_collisionBodyPartsRef, COLLISION_BODY_PART_TYPE.L_leg,
				new CollisionBodyPart(20, false, new Vector2Rectangle(new Vector2(0.2, 0.6), undefined, new Vector2(0.45, 1), undefined)),
			);
			// RIGHT LEG
			ds_map_add(
				_collisionBodyPartsRef, COLLISION_BODY_PART_TYPE.R_leg,
				new CollisionBodyPart(20, false, new Vector2Rectangle(new Vector2(0.55, 0.6), undefined, new Vector2(0.8, 1), undefined)),
			);
		} break;
		default:
		{
			throw(string("Trying to initialize collision body parts with unknown body type {0}!",_collisionBodyType));
		}
	}
}