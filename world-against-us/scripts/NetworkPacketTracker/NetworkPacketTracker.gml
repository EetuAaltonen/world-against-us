function NetworkPacketTracker() constructor
{
	outgoing_sequence_number = -1;
	max_sequence_number = 255;
	in_flight_packets = ds_list_create();
	expected_sequence_number = 0;
	expected_acknowledgment_id = 0;
	pending_ack_range = ds_list_create();
	dropped_packet_count = 0;
	
	static Update = function()
	{
		var inFlightPacketCount = ds_list_size(in_flight_packets);
		for (var i = 0; i < inFlightPacketCount; i++)
		{
			var inFlightPacket = in_flight_packets[| i];
			if (!is_undefined(inFlightPacket))
			{
				if (inFlightPacket.timeout_timer.IsTimerStopped())
				{
					if (!is_undefined(inFlightPacket.ack_timeout_callback_func))
					{
						if (script_exists(inFlightPacket.ack_timeout_callback_func) && inFlightPacket.acknowledgment_attempt <= inFlightPacket.max_acknowledgment_attempts)
						{
							show_debug_message(string("Acknowledgment timeout attempt {0} with message type {1} and sequence number {2} timed out", inFlightPacket.acknowledgment_attempt, inFlightPacket.header.message_type, inFlightPacket.header.sequence_number));
							// CALL TIMEOUT CALLBACK FUNCTION
							inFlightPacket.ack_timeout_callback_func(inFlightPacket);
							inFlightPacket.acknowledgment_attempt++;
						} else {
							show_message(string("Acknowledgment with message type {0} and sequence number {1} timed out", inFlightPacket.header.message_type, inFlightPacket.header.sequence_number));
							// DISCONNECT AFTER FAILED ATTEMPTS
							DeleteDSListValueByIndex(in_flight_packets, i--);
							inFlightPacketCount = ds_list_size(in_flight_packets);
							global.NetworkHandlerRef.DisconnectTimeout();
						}
					} else {
						if (inFlightPacket.acknowledgment_attempt <= inFlightPacket.max_acknowledgment_attempts)
						{
							show_message(string("Acknowledgment timeout attempt {0} with message type {1} and sequence number {2} timed out without a callback", inFlightPacket.acknowledgment_attempt, inFlightPacket.header.message_type, inFlightPacket.header.sequence_number));
							// WAIT WITHOUT TIMEOUT CALLBACK FUNCTION
							inFlightPacket.acknowledgment_attempt++;
							inFlightPacket.timeout_timer.StartTimer();
						} else {
							show_message(string("Acknowledgment with message type {0} and sequence number {1} timed out without a callback", inFlightPacket.header.message_type, inFlightPacket.header.sequence_number));
							// DISCONNECT AFTER FAILED ATTEMPTS
							DeleteDSListValueByIndex(in_flight_packets, i--);
							inFlightPacketCount = ds_list_size(in_flight_packets);
							global.NetworkHandlerRef.DisconnectTimeout();
						}
					}
				} else {
					inFlightPacket.timeout_timer.Update();
				}
			}
		}
	}
	
	static PatchNetworkPacketAckRange = function(_networkPacket)
	{
		var isAckRangePatched = true;
		if (ds_list_size(pending_ack_range) > 0)
		{
			// CLONE ACK RANGE VALUES
			_networkPacket.header.ack_count = ds_list_size(pending_ack_range);
			ds_list_copy(_networkPacket.header.ack_range, pending_ack_range);
			
			// CLEAR PENDING ACK RANGE
			ClearDSListAndDeleteValues(pending_ack_range);
		} else {
			if (_networkPacket.header.message_type == MESSAGE_TYPE.ACKNOWLEDGMENT)
			{
				show_debug_message("Unnecessary MESSAGE_TYPE.ACKNOWLEDGMENT dropped");
				isAckRangePatched = false;
			}
		}
		return isAckRangePatched;
	}
	
	static PatchNetworkPacketSequenceNumber = function(_networkPacket)
	{
		var isSequenceNumberPatched = true;
		if (++outgoing_sequence_number > max_sequence_number) { outgoing_sequence_number = 0; }
		_networkPacket.header.sequence_number = outgoing_sequence_number;
		// DON'T TRACK SEPARATE ACKNOWLEDGMENT RESPONSES
		if (_networkPacket.header.message_type != MESSAGE_TYPE.ACKNOWLEDGMENT &&
			_networkPacket.header.message_type != MESSAGE_TYPE.DISCONNECT_FROM_HOST)
		{
			_networkPacket.timeout_timer.StartTimer();
			ds_list_add(in_flight_packets, _networkPacket);
		}
		return isSequenceNumberPatched;
	}
	
	static ProcessAckRange = function(_ackCount, _ackRange)
	{
		var isAcknowledgmentProceed = true;
		for (var i = 0; i < _ackCount; i++)
		{
			var acknowledgmentId = _ackRange[| i] ?? 0;
			RemoveTrackedInFlightPacket(acknowledgmentId);
		}
		return isAcknowledgmentProceed;
	}
	
	static ProcessSequenceNumber = function(_sequenceNumber, _messageType)
	{
		var isCheckedAndProceed = false;
		// TODO: Verify what happens when sequence number is wrapped back to 0
		// If incoming packet still has seq number 126 or 127??
		if (_messageType != MESSAGE_TYPE.DISCONNECT_FROM_HOST)
		{
			if (_sequenceNumber == expected_sequence_number)
			{
				// SUCCESSFULLY RECEIVED THE EXPECTED
				expected_sequence_number = _sequenceNumber + 1;
				if (_messageType != MESSAGE_TYPE.ACKNOWLEDGMENT)
				{
					ds_list_add(pending_ack_range, _sequenceNumber);
				}
			} else if (_sequenceNumber > expected_sequence_number)
			{
				// PATCH TO PAST ONE OF MOST RECENT
				show_debug_message(string("Received sequence number {0} greater than expected {1}", _sequenceNumber, expected_sequence_number));
				expected_sequence_number = _sequenceNumber + 1;
				if (_messageType != MESSAGE_TYPE.ACKNOWLEDGMENT)
				{
					ds_list_add(pending_ack_range, _sequenceNumber);
				}
			} else if (_sequenceNumber < expected_sequence_number)
			{
				// DROP STALE DATA
				show_debug_message(string("Received sequence number {0} smaller than expected {1}", _sequenceNumber, expected_sequence_number));
				isCheckedAndProceed = false;
			}
			if (expected_sequence_number > max_sequence_number) { expected_sequence_number = 0; }
			isCheckedAndProceed = true;
		} else {
			// PROCESS ALL DISCONNECT FROM HOST MESSAGES
			isCheckedAndProceed = true;	
		}
		return isCheckedAndProceed;
	}
	
	static RemoveTrackedInFlightPacket = function(_sequenceNumber)
	{
		var isPacketRemoved = false;
		var inFlightPacketCount = ds_list_size(in_flight_packets);
		for (var i = 0; i < inFlightPacketCount; i++)
		{
			var inFlightPacket = in_flight_packets[| i];
			if (!is_undefined(inFlightPacket))
			{
				if (inFlightPacket.header.sequence_number == _sequenceNumber)
				{
					DeleteDSListValueByIndex(in_flight_packets, i--);
					inFlightPacketCount = ds_list_size(in_flight_packets);
					isPacketRemoved = true;
					break;
				}
			}
		}
		return isPacketRemoved;
	}
	
	static ResetNetworkPacketTracking = function()
	{
		outgoing_sequence_number = -1;
		expected_sequence_number = 0;
		expected_acknowledgment_id = 0;
		dropped_packet_count = 0;
		
		ClearDSListAndDeleteValues(in_flight_packets);
		ClearDSListAndDeleteValues(pending_ack_range);
	}
	
	static ClearInFlightPacketsByMessageType = function(_messageType)
	{
		var inFlightPacketCount = ds_list_size(in_flight_packets);
		for (var i = 0; i < inFlightPacketCount; i++)
		{
			var inFlightPacket = in_flight_packets[| i];
			if (inFlightPacket.header.message_type == _messageType)
			{
				DeleteDSListValueByIndex(in_flight_packets, i--);
				inFlightPacketCount = ds_list_size(in_flight_packets);
			}
		}
	}
}