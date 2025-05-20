// INHERIT THE PARENT EVENT
event_inherited();
if (instanceState != object_index)
{
	instanceState = event_object;
} else {
	electricalNetwork.electricOutputPower = (facility.inventory.GetItemCount() > 0) ? electricalNetwork.maxElectricOutputPower : 0;
}