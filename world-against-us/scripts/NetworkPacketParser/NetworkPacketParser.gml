function NetworkPacketParser() constructor
{
	static ParsePacket = function(_msg)
	{
		var parsedNetworkPacket = undefined;
		try
		{
			buffer_seek(_msg, buffer_seek_start, 0);
			var messageType = buffer_read(_msg, buffer_u8);
			var clientId = buffer_read(_msg, buffer_string);
			var acknowledgmentId = buffer_read(_msg, buffer_s8);
			var parsedHeader = new NetworkPacketHeader(messageType, clientId);
			if (acknowledgmentId != -1)
			{
				parsedHeader.SetAcknowledgmentId(acknowledgmentId);
			}
			
			// SET BUFFER TO THE INDEX BEFORE THE PAYLOAD
			buffer_seek(_msg, buffer_seek_relative, 0);
			var payload = buffer_read(_msg, buffer_string);
			
			parsedNetworkPacket = new NetworkPacket(parsedHeader, payload);
		} catch (error)
		{
			show_debug_message(error);
			show_message(error);
		}
		return parsedNetworkPacket;
	}
}