function MetadataMagazine(_caliber, _magazine_size) : Metadata() constructor
{
	caliber = _caliber;
    magazine_size = _magazine_size;
	bullet_count = 0;
	
	static ToJSONStruct = function()
	{
		return {
			caliber: caliber,
			magazine_size: magazine_size,
			bullet_count: bullet_count
		}
	}
}