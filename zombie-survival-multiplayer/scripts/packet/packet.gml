function Packet(_clientId, _messageType) constructor
{
	client_id = _clientId;
	message_type = _messageType;
	content = [];
	
	static AddContent = function(_key, _data)
	{
		array_push(content, { key: _key, data: _data });
	}
}