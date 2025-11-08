// INHERIT THE PARENT EVENT
event_inherited();

ReleaseVariableFromMemory(inputDeviceMovement);
movementInput = undefined;

ReleaseVariableFromMemory(inputDeviceMouse);
inputDeviceMouse = undefined;

ReleaseVariableFromMemory(previousPosition);
previousPosition = undefined;

ReleaseVariableFromMemory(autopilotInputTimer);
autopilotInputTimer = undefined;