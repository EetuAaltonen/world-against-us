function NetworkPacketHeader(_message_type) constructor
{
	message_type = _message_type;
	client_id = global.NetworkHandlerRef.client_id;
	sequence_number = -1;
	acknowledgment_id = -1;
}