function InitializeParticleBulletCasing(_partType)
{
	part_type_size(_partType, 0.4, 0.4, 0, 0);
	part_type_scale(_partType, 1, 1);
	part_type_alpha3(_partType, 1, 1, 0.5);
	part_type_speed(_partType, 6, 7, -0.05, false);
	part_type_gravity(_partType, 0.3, 270);
	part_type_blend(_partType, false);
	part_type_life(_partType, 40, 40);
}