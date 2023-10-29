function NetworkPacket(_header, _payload, _priority = 0) constructor
{
	header = _header;
	payload = _payload;
	priority = _priority;
	max_acknowledgment_attemps = 3;
	acknowledgment_attemp = 0;
}