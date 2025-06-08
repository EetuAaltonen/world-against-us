// INHERIT THE PARENT EVENT
event_inherited();

image_speed = 0;

// SKELETAL ANIMATION
var skeletalAnimationEvents = ds_map_create();
ds_map_add(
	skeletalAnimationEvents, "walk",
	[
		// TODO: Animation Event Example
		/*new SkeletalAnimationEvent(ev_draw, "draw_color_random", function(_instanceRef) {
			_instanceRef.image_blend = make_color_rgb(random(255), random(255), random(255));
		}),*/
	]
);
var skeletalAnimationSliceGroups = ds_list_create();
var playbackFunction = function(_animationSliceGroupRef, _animationSkeletalRef)
{
	var instanceRef = _animationSkeletalRef.instance_ref;
	var boneData = ds_map_create();
	_animationSkeletalRef.animation_skeleton.GetBoneDataByName("b_weapon_slot", boneData);
	
	var greenLineVector = new Vector2(300, 0);
	greenLineVector.Rotate(-(boneData[? "worldAngleX"] + (90 * -(_animationSliceGroupRef.instance_ref.image_xscale))));
	var dirGunline = point_direction(boneData[? "worldX"], boneData[? "worldY"], boneData[? "worldX"] - greenLineVector.X, boneData[? "worldY"] - greenLineVector.Y);
	var gunLineAngle = 180 - (90 * (sin(degtorad(dirGunline))  + 1));
		
	var aimDir = point_direction(boneData[? "worldX"], boneData[? "worldY"], mouse_x, mouse_y + 9);
	var aimAngle = 180 - (90 * (sin(degtorad(aimDir))  + 1));
	
	_animationSliceGroupRef.current_frame += (gunLineAngle <= aimAngle) ? (aimAngle - gunLineAngle) * 0.2 : -(gunLineAngle - aimAngle) * 0.2;
	
	if (_animationSliceGroupRef.current_frame > _animationSliceGroupRef.frame_count) { _animationSliceGroupRef.current_frame = 0; }
	if (_animationSliceGroupRef.current_frame < 0) { _animationSliceGroupRef.current_frame = _animationSliceGroupRef.frame_count; }
	
	with (instanceRef)
	{
		skeleton_animation_set_frame(0, _animationSliceGroupRef.current_frame);
	}
	_animationSkeletalRef.current_frame = _animationSliceGroupRef.current_frame;
}
var playbackFunctionWalk = function(_animationSliceGroupRef, _animationSkeletalRef)
{
	var instanceRef = _animationSkeletalRef.instance_ref;
	if (instanceRef.dirSpeed.hSpeed != 0 ||
		instanceRef.dirSpeed.vSpeed != 0)
	{
		if (instanceRef.dirSpeed.hSpeed > 0)
		{
			_animationSliceGroupRef.current_frame += sign(instanceRef.image_xscale);
		} else {
			_animationSliceGroupRef.current_frame -= sign(instanceRef.image_xscale);
		}

		if (_animationSliceGroupRef.current_frame > _animationSliceGroupRef.frame_count) { _animationSliceGroupRef.current_frame = 0; }
		if (_animationSliceGroupRef.current_frame < 0) { _animationSliceGroupRef.current_frame = _animationSliceGroupRef.frame_count; }
	} else {
		_animationSliceGroupRef.current_frame = 0;
	}
}
ds_list_add(skeletalAnimationSliceGroups, new SkeletalAnimationSliceGroup(self, "rifle_aim", "upperbody", playbackFunction));
ds_list_add(skeletalAnimationSliceGroups, new SkeletalAnimationSliceGroup(self, "walk", "lowerbody", playbackFunctionWalk));

skeletalAnimation = new SkeletalAnimationSlice(self, skeletalAnimationEvents, skeletalAnimationSliceGroups);
skeletalAnimation.SetAnimation("rifle_aim", 1, true);

// INIT COLLIDER AND COLLISION BODY
var collisionBody = new CollisionBody(
	COLLISION_BODY_TYPE.Humanoid
);
collider = new Collider(
	COLLIDER_TYPE.Circle,
	sprite_width * 0.5, 
	-(bbox_bottom - bbox_top) * 0.5,
	collisionBody
);

baseAcceleration = 0.25;
acceleration = baseAcceleration;
baseMaxSpeed = 2.5;
maxSpeed = baseMaxSpeed;
hSpeed = 0;
vSpeed = 0;

// CONTROLS
movementInput = new DeviceInputMovement(0, 0, 0, 0);
prevMovementInput = new DeviceInputMovement(0, 0, 0, 0);

// EQUIPMENT POSITIONS
equipmentOriginOffset = new Vector2(0, -88);

// SPAWN WEAPON
// TODO: Move the weapon under character struct
//weapon = instance_create_depth(x, y, depth - 1, objWeapon);
//weapon.owner = self;

// NETWORKING
previousPosition = new Vector2(0, 0);

// DEBUG AUTOPILOT BOT
autopilotMode = false;
autopilotInputTimer = new Timer(500);