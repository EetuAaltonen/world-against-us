// INHERIT THE PARENT EVETN
event_inherited();

if (!is_undefined(character)) character.Update();
if (!is_undefined(aiBase)) aiBase.Update();