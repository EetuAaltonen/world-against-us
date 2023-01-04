// INHERITED EVENT
event_inherited();

interactionText = "Loot";
interactionFunction = function()
{
	if (!requestContent)
	{
		// NETWORKING CONTAINER REQUEST CONTENT
		var networkBuffer = global.ObjNetwork.client.CreateBuffer(MESSAGE_TYPE.CONTAINER_REQUEST_CONTENT);
			
		buffer_write(networkBuffer, buffer_text , containerId);
		global.ObjNetwork.client.SendPacketOverUDP(networkBuffer);
			
		requestContent = true;
	}
}

inventory = undefined;
requestContent = false;