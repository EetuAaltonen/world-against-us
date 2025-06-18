function ConstructionBlueprint(_materials, _output_building_name, _output_building_object) constructor
{
	materials = _materials;
	output_building_name = _output_building_name;
	output_building_object = _output_building_object;
	
	static OnDestroy = function(_struct = self)
	{
		ReleaseVariableFromMemory(_struct.materials);
		_struct.materials = undefined;
	}
}