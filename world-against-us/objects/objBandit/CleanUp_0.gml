// INHERIT THE PARENT EVENT
event_inherited();

// DELETE AI BASE
DeleteStruct(aiBandit);

// DELETE AI STATES MAP
DestroyDSMapAndDeleteValues(aiStates);
aiStates = undefined;