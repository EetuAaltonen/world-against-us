// INHERIT THE PARENT EVENT
event_inherited();

// DESTROY CHARACTER WHEN NEEDED
// NOT CALLED HERE TO PREVENT PLAYER DATA LOSS
/*character.OnDestroy();
character = undefined;*/

 // DELETE AI BASE
DeleteStruct(aiBase);
aiBase = undefined;

// DELETE AI STATES MAP
DestroyDSMapAndDeleteValues(aiStates);
aiStates = undefined;