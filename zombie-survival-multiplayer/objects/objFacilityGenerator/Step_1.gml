// Inherit the parent event
event_inherited();

electricalNetwork.electricOutputPower = (facility.inventory.GetItemCount() > 0) ? electricalNetwork.maxElectricOutputPower : 0;