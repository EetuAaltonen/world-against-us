function NetworkPacket(_header, _payload, _priority = PACKET_PRIORITY.DEFAULT, _ack_timeout_callback_func = undefined) constructor
{
	header = _header;
	payload = _payload;
	priority = _priority;
	
	ack_timeout_callback_func = _ack_timeout_callback_func;
	max_acknowledgment_attempts = 2;
	acknowledgment_attempt = 1;
	timeout_timer = new Timer(TimerFromSeconds(2));
}