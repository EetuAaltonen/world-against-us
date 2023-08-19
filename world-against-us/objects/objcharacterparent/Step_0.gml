if (!is_undefined(character))
{
	if (character.is_dead)
	{
		instance_destroy();
	} else {
		character.Update();
	}
}