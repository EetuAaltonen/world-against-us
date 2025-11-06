// INHERIT THE PARENT EVENT
event_inherited();

ReleaseVariableFromMemory(movementInput);
movementInput = undefined;

ReleaseVariableFromMemory(prevMovementInput);
prevMovementInput = undefined;

ReleaseVariableFromMemory(inputDeviceMouse);
inputDeviceMouse = undefined;

ReleaseVariableFromMemory(previousPosition);
previousPosition = undefined;

ReleaseVariableFromMemory(autopilotInputTimer);
autopilotInputTimer = undefined;