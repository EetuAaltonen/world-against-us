function Packet(_clientId, _messageType) constructor
{
	client_id = _clientId;
	message_type = _messageType;
	content = [];
	
	static AddContent = function(_key, _value)
	{
		array_push(content, { key: _key, value: _value });
	}
}