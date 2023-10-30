function NetworkPacketTracker() constructor
{
	acknowledgment_id = -1;
	last_acknowledgment_id = 100;
	acknowledgment_timeout_timer = new Timer(TimerFromSeconds(3));
	in_flight_packets = ds_map_create();
	
	static SetNetworkPacketAcknowledgment = function(_networkPacket)
	{
		var isAcknowledgmentSet = false;
		show_debug_message("Pre in_flight_packets count {0}", ds_map_size(in_flight_packets));
		
		var nextAcknowledgmentId = FetchNextAcknowledgmentId();
		if (nextAcknowledgmentId != -1)
		{
			_networkPacket.acknowledgment_attempt = 1;
			if (ds_map_add(in_flight_packets, acknowledgment_id, _networkPacket))
			{
				_networkPacket.header.SetAcknowledgmentId(acknowledgment_id);	
				acknowledgment_timeout_timer.StartTimer();
				isAcknowledgmentSet = true;
			}
		}
		
		if (!isAcknowledgmentSet) { show_debug_message("Failed to set acknowledgment for network packet with message type {0}", _networkPacket.header.message_type); }
		return isAcknowledgmentSet;
	}
	
	static FetchNextAcknowledgmentId = function()
	{
		var nextAcknowledgmentId = -1;
		var acknowledgmentId = acknowledgment_id + 1;
		var idFetchAttempts = 0;
		var maxIdFetchAttempts = 127;
		while (idFetchAttempts <= maxIdFetchAttempts)
		{
			if (is_undefined(in_flight_packets[? nextAcknowledgmentId]))
			{
				nextAcknowledgmentId = acknowledgmentId;
				acknowledgment_id = acknowledgmentId;
				break;
			}
			acknowledgmentId++;
			if (acknowledgmentId > last_acknowledgment_id) { acknowledgmentId = 0; }
			idFetchAttempts++;
		}
		
		if (nextAcknowledgmentId == -1)
		{
			show_debug_message("Failed to fetch next actknowledgment id for network packet, in_flight_packets count {0}", ds_map_size(in_flight_packets));
		}
		return nextAcknowledgmentId;
	}
	
	static UpdateInFlightNetworkPackets = function(_networkPacket)
	{
		if (ds_map_size(in_flight_packets) > 0)
		{
			if (acknowledgment_timeout_timer.IsTimerStopped())
			{
				var lastAcknowledgmentNetworkPacket = in_flight_packets[? acknowledgment_id];
				if (!is_undefined(lastAcknowledgmentNetworkPacket))
				{
					if (lastAcknowledgmentNetworkPacket.acknowledgment_attempt < lastAcknowledgmentNetworkPacket.max_acknowledgment_attempts)
					{
						lastAcknowledgmentNetworkPacket.acknowledgment_attempt++;
						if (global.NetworkHandlerRef.AddPacketToQueue(lastAcknowledgmentNetworkPacket))
						{
							show_debug_message("Resending acknowledgment {0}", lastAcknowledgmentNetworkPacket.header.acknowledgment_id);
							acknowledgment_timeout_timer.StartTimer();
						} else {
							show_debug_message("Failed to resend acknowledgment {0}", lastAcknowledgmentNetworkPacket.header.acknowledgment_id);
						}
					} else {
						show_message("Failed to reach the server. Disconnecting...");
						global.NetworkHandlerRef.DisconnectSocket();
						if (room == roomMainMenu)
						{
							// RESET GUI STATE MAIN MENU
							if (!global.GUIStateHandlerRef.ResetGUIStateMainMenu())
							{
								// TODO: Move this check inside the actual ResetGUIStateMainMenu function
								// with proper error handling
								show_debug_message("Failed to reset GUI state Main Menu");
							}
						} else {
							room_goto(roomMainMenu);
						}
					}
				}
			} else {
				acknowledgment_timeout_timer.Update();	
			}
		}
	}
	
	static CheckNetworkPacketAcknowledgment = function(_networkPacket)
	{
		var isCheckedAndProceed = false;
		var acknowledgmentId = _networkPacket.header.acknowledgment_id;
		if (acknowledgmentId != -1)
		{
			if (!is_undefined(in_flight_packets[? acknowledgmentId]))
			{
				if (acknowledgmentId < acknowledgment_id)
				{
					show_debug_message("Old acknowledgment received {0}", acknowledgmentId);
					isCheckedAndProceed = false;
				} else {
					show_debug_message("The latest acknowledgment succesfully received {0}", acknowledgmentId);
					isCheckedAndProceed = true;
				}
				ds_map_delete(in_flight_packets, acknowledgmentId);
			} else {
				show_debug_message("Unknown acknowledgment received {0}", acknowledgmentId);
				isCheckedAndProceed = false;
			}
		} else {
			isCheckedAndProceed = true;
		}
		return isCheckedAndProceed;
	}
	
	static ClearInFlightPacketsByMessageType = function(_messageType)
	{
		for (var key = ds_map_find_first(in_flight_packets); !is_undefined(key); key = ds_map_find_next(in_flight_packets, key))
		{
			var inFlightPacket = in_flight_packets[? key];
			if (!is_undefined(inFlightPacket))
			{
				var networkpacketHeader = inFlightPacket.header;
				if (!is_undefined(networkpacketHeader))
				{
					if (networkpacketHeader.message_type == _messageType)
					{
						ds_map_delete(in_flight_packets, key);
					}
				}
			}
		}
		acknowledgment_timeout_timer.running_time = 0;
	}
	
	static ResetNetworkPacketTracking = function()
	{
		acknowledgment_id = -1;
		acknowledgment_timeout_timer.running_time = 0;
		ds_map_clear(in_flight_packets);
	}
}