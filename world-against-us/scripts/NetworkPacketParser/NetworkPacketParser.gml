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
			// SET BUFFER TO THE INDEX BEFORE CONTENT
			buffer_seek(_msg, buffer_seek_relative, 0);
			
			var parsedHeader = new NetworkPacketHeader(messageType, clientId);
			parsedNetworkPacket = new NetworkPacket(parsedHeader, undefined);
		} catch (error)
		{
			show_debug_message(error);
			show_message(error);
		}
		return parsedNetworkPacket;
	}
}