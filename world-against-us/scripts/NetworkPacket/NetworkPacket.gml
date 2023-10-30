function NetworkPacket(_header, _payload, _priority = 0) constructor
{
	header = _header;
	payload = _payload;
	priority = _priority;
	max_acknowledgment_attempts = 3;
	acknowledgment_attempt = 0;
}