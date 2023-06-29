// INHERIT THE PARENT EVENT
event_inherited();

electricalNetwork.electricOutputPower = (facility.inventory.GetItemCount() > 0) ? electricalNetwork.maxElectricOutputPower : 0;