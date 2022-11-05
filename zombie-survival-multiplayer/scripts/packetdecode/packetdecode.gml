function PacketDecodeHeader(_networkBuffer)
{
	buffer_seek(_networkBuffer, buffer_seek_start, 0);
	var clientId = buffer_read(_networkBuffer, buffer_string);
	var messageType = buffer_read(_networkBuffer, buffer_u8);
	// Set buffer to the index before content
	buffer_seek(_networkBuffer, buffer_seek_relative, 0); // Step 1 byte
	
	return new PacketHeader(clientId, messageType);
}