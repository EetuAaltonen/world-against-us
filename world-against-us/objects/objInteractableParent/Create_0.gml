// INHERIT THE PARENT EVENT
event_inherited();

interactionText = "Interact";
interactionFunction = undefined; // OVERRIDE THIS VARIABLE
interactionRange = clamp(max(sprite_width, sprite_height), 60, 100);