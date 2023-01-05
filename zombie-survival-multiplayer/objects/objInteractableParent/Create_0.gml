// Inherit the parent event
event_inherited();

defaultLayer = layer;

interactionText = "Interact";
interactionFunction = undefined;
interactionRange = clamp(max(sprite_width, sprite_height), 60, 100);