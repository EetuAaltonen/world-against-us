function NetworkPacketTracker() constructor
{
	outgoing_sequence_number = -1;
	max_sequence_number = 255;
	in_flight_packets = ds_list_create();
	expected_sequence_number = 0;
	pending_ack_range = ds_list_create();
	packet_loss_count = 0;
	
	static Update = function()
	{
		var inFlightPacketCount = ds_list_size(in_flight_packets);
		for (var i = 0; i < inFlightPacketCount; i++)
		{
			var inFlightPacket = in_flight_packets[| i];
			if (!is_undefined(inFlightPacket))
			{
				inFlightPacket.timeout_timer.Update();
				if (inFlightPacket.timeout_timer.IsTimerStopped())
				{
					if (!is_undefined(inFlightPacket.ack_timeout_callback_func))
					{
						if (script_exists(inFlightPacket.ack_timeout_callback_func) && inFlightPacket.acknowledgment_attempt <= inFlightPacket.max_acknowledgment_attempts)
						{
							// CONSOLE LOG
							var consoleLog = string(
								"Acknowledgment timeout attempt {0} with message type {1} and sequence number {2} timed out",
								inFlightPacket.acknowledgment_attempt, inFlightPacket.header.message_type, inFlightPacket.header.sequence_number
							);
							global.ConsoleHandlerRef.AddConsoleLog(CONSOLE_LOG_TYPE.WARNING, consoleLog);
							
							// CALL TIMEOUT CALLBACK FUNCTION
							inFlightPacket.ack_timeout_callback_func(inFlightPacket);
							inFlightPacket.acknowledgment_attempt++;
						} else {
							// CONSOLE LOG
							var consoleLog = string(
								"Acknowledgment with message type {0} and sequence number {1} timed out",
								inFlightPacket.header.message_type, inFlightPacket.header.sequence_number
							);
							global.ConsoleHandlerRef.AddConsoleLog(CONSOLE_LOG_TYPE.WARNING, consoleLog);
							
							// DISCONNECT AFTER FAILED ATTEMPTS
							DeleteDSListValueByIndex(in_flight_packets, i--);
							inFlightPacketCount = ds_list_size(in_flight_packets);
							global.NetworkHandlerRef.DisconnectTimeout();
						}
					} else {
						if (inFlightPacket.acknowledgment_attempt <= inFlightPacket.max_acknowledgment_attempts)
						{
							// CONSOLE LOG
							var consoleLog = string(
								"Acknowledgment timeout attempt {0} with message type {1} and sequence number {2} timed out without a callback",
								inFlightPacket.acknowledgment_attempt, inFlightPacket.header.message_type, inFlightPacket.header.sequence_number
							);
							global.ConsoleHandlerRef.AddConsoleLog(CONSOLE_LOG_TYPE.WARNING, consoleLog);
							
							// WAIT WITHOUT TIMEOUT CALLBACK FUNCTION
							inFlightPacket.acknowledgment_attempt++;
							inFlightPacket.timeout_timer.StartTimer();
						} else {
							// CONSOLE LOG
							var consoleLog = string(
								"Acknowledgment with message type {0} and sequence number {1} timed out without a callback",
								inFlightPacket.header.message_type, inFlightPacket.header.sequence_number
							);
							global.ConsoleHandlerRef.AddConsoleLog(CONSOLE_LOG_TYPE.WARNING, consoleLog);
							

							// DISCONNECT AFTER FAILED ATTEMPTS
							DeleteDSListValueByIndex(in_flight_packets, i--);
							inFlightPacketCount = ds_list_size(in_flight_packets);
							global.NetworkHandlerRef.DisconnectTimeout();
						}
					}
				}
			}
		}
	}
	
	static PatchNetworkPacketAckRange = function(_networkPacket)
	{
		var isAckRangePatched = false;
		if (_networkPacket.delivery_policy.patch_ack_range)
		{
			if (ds_list_size(pending_ack_range) > 0)
			{
				// CLONE ACK RANGE VALUES
				_networkPacket.header.ack_count = ds_list_size(pending_ack_range);
				ds_list_copy(_networkPacket.header.ack_range, pending_ack_range);
				isAckRangePatched = true;
			} else {
				if (_networkPacket.header.message_type == MESSAGE_TYPE.ACKNOWLEDGMENT)
				{
					global.ConsoleHandlerRef.AddConsoleLog(CONSOLE_LOG_TYPE.WARNING, "Unnecessary MESSAGE_TYPE.ACKNOWLEDGMENT dropped");
				} else {
					isAckRangePatched = true;	
				}
			}
			// PENDING ACK RANGE IS CLEARED AFTER PACKET IS SUCCESSFULLY SENT
		} else {
			// PATCH ACK RANGE SET TO FALSE IN DELIVERY POLICY
			isAckRangePatched = true;
		}
		return isAckRangePatched;
	}
	
	static PatchNetworkPacketSequenceNumber = function(_networkPacket)
	{
		var isSequenceNumberPatched = false;
		if (_networkPacket.delivery_policy.patch_sequence_number)
		{
			if (++outgoing_sequence_number > max_sequence_number) { outgoing_sequence_number = 0; }
			_networkPacket.header.sequence_number = outgoing_sequence_number;
			isSequenceNumberPatched = true;
		} else {
			// PATCH SEQUENCE NUMBER SET TO FALSE IN DELIVERY POLICY
			isSequenceNumberPatched = true;	
		}
		return isSequenceNumberPatched;
	}
	
	static PatchInFlightPacketTrack = function(_networkPacket)
	{
		var isPacketTrackPatched = false;
		if (_networkPacket.delivery_policy.in_flight_track)
		{
			_networkPacket.timeout_timer.StartTimer();
			ds_list_add(in_flight_packets, _networkPacket);
			
			if (is_undefined(_networkPacket.ack_timeout_callback_func))
			{
				var consoleLog = string("Network packet with message type {0} is missing ACK timeout callback function", _networkPacket.header.message_type);
				global.ConsoleHandlerRef.AddConsoleLog(CONSOLE_LOG_TYPE.WARNING, consoleLog);
			}
			
			isPacketTrackPatched = true;
		} else {
			if (!is_undefined(_networkPacket.ack_timeout_callback_func))
			{
				var consoleLog = string("Network packet with message type {0} has unnecessary ACK timeout callback function", _networkPacket.header.message_type);
				global.ConsoleHandlerRef.AddConsoleLog(CONSOLE_LOG_TYPE.WARNING, consoleLog);
			}
			
			// IN-FLIGHT PACKET TRACK SET TO FALSE IN DELIVERY POLICY
			isPacketTrackPatched = true;
		}
		return isPacketTrackPatched;
	}
	
	static OnNetworkPacketSend = function(_networkPacket)
	{
		// PATCH IN-FLIGHT PACKET TRACK
		if (!PatchInFlightPacketTrack(_networkPacket))
		{
			var consoleLog = string("Unable to add network packet with message type {0} to in-flight packet tracking", _networkPacket.header.message_type);
			global.ConsoleHandlerRef.AddConsoleLog(CONSOLE_LOG_TYPE.WARNING, consoleLog);
		}
		
		// CLEAR PENDING ACK RANGE
		if (_networkPacket.delivery_policy.patch_ack_range)
		{
			ClearDSListAndDeleteValues(pending_ack_range);
		}
	}
	
	/// @function			ProcessAckRange(_ackCount, _ackRange)
	/// @description		Loops through a given ACK range
	///						and removes matching packets from in-flight tracking
	/// @param	{number} ackCount
	/// @param	{list} ackRange
	/// @return {bool}
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
	
	/// @function			ProcessSequenceNumber(_sequenceNumber, _messageType)
	/// @description		Checks a given sequence number to validate the correct packet order
	///						and adds valid ones into the pending acknowledgments collection
	/// @param	{number} sequenceNumer
	/// @param	{number} messageType
	/// @return {bool}
	static ProcessSequenceNumber = function(_sequenceNumber, _messageType)
	{
		var isCheckedAndProceed = false;
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
				var consoleLog = string("Received sequence number {0} greater than expected {1}", _sequenceNumber, expected_sequence_number);
				global.ConsoleHandlerRef.AddConsoleLog(CONSOLE_LOG_TYPE.WARNING, consoleLog);
				expected_sequence_number = _sequenceNumber + 1;
				if (_messageType != MESSAGE_TYPE.ACKNOWLEDGMENT)
				{
					ds_list_add(pending_ack_range, _sequenceNumber);
				}
			} else if (_sequenceNumber < expected_sequence_number)
			{
				// DROP STALE DATA
				var consoleLog = string("Received sequence number {0} smaller than expected {1}", _sequenceNumber, expected_sequence_number);
				global.ConsoleHandlerRef.AddConsoleLog(CONSOLE_LOG_TYPE.WARNING, consoleLog);
				// UPDATE PACKET LOSS COUNT
				global.NetworkPacketTrackerRef.UpdatePacketLossCount(1);
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
	
	static UpdatePacketLossCount = function(_droppedPacketCount)
	{
		packet_loss_count += _droppedPacketCount;
		
		// DEBUG MONITOR
		var monitorHandlerRef = global.DebugMonitorNetworkHandlerRef;
		array_push(monitorHandlerRef.packet_loss_samples, packet_loss_count);
		monitorHandlerRef.packet_loss_samples_max_value = max(packet_loss_count, monitorHandlerRef.packet_loss_samples_max_value);
	}
	
	static ResetNetworkPacketTracking = function()
	{
		outgoing_sequence_number = -1;
		expected_sequence_number = 0;
		packet_loss_count = 0;
		
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