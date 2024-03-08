function IsInstanceCharacterInvulnerable(_instance)
{
	var isInvulnerable = true;
	if (instance_exists(_instance))
	{
		isInvulnerable = (!is_undefined(_instance.character)) ? _instance.character.IsInvulnerableState() : true;
	}
	return isInvulnerable;
}