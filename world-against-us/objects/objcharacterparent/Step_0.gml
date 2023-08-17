if (!is_undefined(character))
{
	if (character.isDead)
	{
		instance_destroy();
	} else {
		character.Update();
	}
}