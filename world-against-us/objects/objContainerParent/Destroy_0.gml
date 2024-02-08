// INHERIT THE PARENT EVENT
event_inherited();

if (!is_undefined(inventory))
{
	inventory.OnDestroy();
	inventory = undefined;
}