function NetworkErrorHandler() constructor
{
	static OnDestroy = function()
	{
		// NO PROPERTIES TO DESTROY
		return;
	}
	
	static HandleInvalidRequest = function(_invalidRequestInfo)
	{
		var isRequestHandled = true;
		if (!is_undefined(_invalidRequestInfo))
		{
			// CONSOLE LOG
			var consoleLog = string(
				"Invalid request with MessageType {0}: {1}",
				_invalidRequestInfo.original_message_type,
				_invalidRequestInfo.invalidation_message
			);
			global.ConsoleHandlerRef.AddConsoleLog(CONSOLE_LOG_TYPE.ERROR, consoleLog);
		
			// NOTIFICATION LOG
			var notification = new Notification(
				undefined, _invalidRequestInfo.invalidation_message,
				undefined, NOTIFICATION_TYPE.Log
			);
			global.NotificationHandlerRef.AddNotification(notification);
			
			// CLEAR IN-FLIGHT PACKETS TO CANCEL PENDING ACKNOWLEDGMENT ON INVALID REQUEST
			global.NetworkPacketTrackerRef.ClearInFlightPacketsByMessageType(_invalidRequestInfo.original_message_type);
			
			// REQUEST ACTION
			switch (_invalidRequestInfo.request_action)
			{
				case INVALID_REQUEST_ACTION.DISCONNECT:
				{
					// REQUEST GUI STATE RESET
					global.GUIStateHandlerRef.RequestGUIStateReset();
					// REQUEST DISCONNECT SOCKET
					global.NetworkHandlerRef.RequestDisconnectSocket();
				} break;
				case INVALID_REQUEST_ACTION.CANCEL_ACTION:
				{
					// REQUEST GUI STATE RESET
					global.GUIStateHandlerRef.RequestGUIStateReset();
				} break;
				case INVALID_REQUEST_ACTION.IGNORE:
				{
					// IGNORE
				} break;
				default:
				{
					// REQUEST GUI STATE RESET
					global.GUIStateHandlerRef.RequestGUIStateReset();
					// REQUEST DISCONNECT SOCKET
					global.NetworkHandlerRef.RequestDisconnectSocket();
				} break;
			}
		}
		return isRequestHandled;
	}
	
	static HandleServerError = function(_networkPacket)
	{
		var isErrorHandled = false;
		var errorMessage = _networkPacket.payload[$ "error"] ?? "Unknown server error";
		var consoleLog = string("{0}. Disconnecting...", errorMessage);
		// CONSOLE LOG
		global.ConsoleHandlerRef.AddConsoleLog(CONSOLE_LOG_TYPE.ERROR, consoleLog);
		
		// NOTIFICATION LOG
		var notification = new Notification(
			undefined, "Internal server error, something went wrong",
			undefined, NOTIFICATION_TYPE.Log
		);
		global.NotificationHandlerRef.AddNotification(notification);
		
		// FORCE DELETE SOCKET
		isErrorHandled = global.NetworkHandlerRef.DeleteSocket();
		return isErrorHandled;
	}
}