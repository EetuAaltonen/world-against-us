function NetworkPacketHeader(_message_type) constructor
{
	message_type = _message_type;
	client_id = global.NetworkHandlerRef.client_id;
	acknowledgment_id = -1;
	
	static SetClientId = function(_client_id)
	{
		client_id = _client_id;
	}
	
	static SetAcknowledgmentId = function(_acknowledgment_id)
	{
		acknowledgment_id = _acknowledgment_id;
	}
}