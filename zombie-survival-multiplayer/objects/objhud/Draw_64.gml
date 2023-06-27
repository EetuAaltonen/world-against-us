// HUD BACKGROUND
draw_sprite_ext(sprGUIBg, 0, 0, global.GUIH - hudHeight, global.GUIW, hudHeight, 0, c_black, hudAlpha);

hudElementHealth.Draw();

if (instance_exists(global.ObjPlayer))
{
	if (!is_undefined(global.ObjPlayer.character))
	{
		hudElementFullness.Draw();
		hudElementHydration.Draw();
		hudElementEnergy.Draw();
	}
	
	if (instance_exists(global.ObjWeapon))
	{
		hudElementMagazine.Draw();
	}
}