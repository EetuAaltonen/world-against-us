function NetworkPacketHeader(_message_type) constructor
{
	message_type = _message_type;
	client_id = global.NetworkHandlerRef.client_id;
	sequence_number = 0;
	ack_count = 0;
	ack_range = ds_list_create();
}