// Inherit the parent event
event_inherited();

electricalNetwork.electricOutputPower = (inventory.GetItemCount() > 0) ? electricalNetwork.maxElectricOutputPower : 0;