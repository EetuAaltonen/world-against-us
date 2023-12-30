function NetworkErrorHandler() constructor
{
	static OnDestroy = function()
	{
		// NO PROPERTIES TO DESTROY
		return;
	}
	
	static HandleInvalidRequest = function(_networkPacket)
	{
		var isRequestHandled = true;
		var errorOriginalMessageType = _networkPacket.payload[$ "message_type"] ?? MESSAGE_TYPE.INVALID_REQUEST;
		var errorMessage = _networkPacket.payload[$ "message"] ?? "Invalid request";
		var consoleLog = string("Invalid request with MessageType {0}: {1}", errorOriginalMessageType, errorMessage);
		// ADD CONSOLE LOG
		global.ConsoleHandlerRef.AddConsoleLog(CONSOLE_LOG_TYPE.ERROR, consoleLog);
		
		// ADD NOTIFICATION
		var notification = new Notification(
			undefined, errorMessage,
			undefined, NOTIFICATION_TYPE.Log
		);
		global.NotificationHandlerRef.AddNotification(notification);
							
		// CLEAR IN-FLIGHT PACKETS TO CANCEL PENDING ACKNOWLEDGMENT ON INVALID REQUEST
		global.NetworkPacketTrackerRef.ClearInFlightPacketsByMessageType(errorOriginalMessageType);
							
		// REQUEST GUI STATE RESET
		global.GUIStateHandlerRef.RequestGUIStateReset();
		
		// REQUEST DISCONNECT SOCKET ON SERTAIN MESSAGE TYPES
		if (errorOriginalMessageType == MESSAGE_TYPE.CONNECT_TO_HOST ||
			errorOriginalMessageType == MESSAGE_TYPE.REQUEST_JOIN_GAME ||
			errorOriginalMessageType == MESSAGE_TYPE.SYNC_WORLD_STATE ||
			errorOriginalMessageType == MESSAGE_TYPE.SYNC_WORLD_STATE_WEATHER ||
			errorOriginalMessageType == MESSAGE_TYPE.SYNC_INSTANCE ||
			errorOriginalMessageType == MESSAGE_TYPE.DISCONNECT_FROM_HOST ||
			errorOriginalMessageType == MESSAGE_TYPE.PING ||
			errorOriginalMessageType == MESSAGE_TYPE.PONG ||
			errorOriginalMessageType == MESSAGE_TYPE.CLIENT_ERROR
		)
		{
			global.NetworkHandler.RequestDisconnectSocket();
		}
		return isRequestHandled;
	}
	
	static HandleServerError = function(_networkPacket)
	{
		var isErrorHandled = false;
		var errorMessage = _networkPacket.payload[$ "error"] ?? "Unknown server error";
		var consoleLog = string("{0}. Disconnecting...", errorMessage);
		// ADD CONSOLE LOG
		global.ConsoleHandlerRef.AddConsoleLog(CONSOLE_LOG_TYPE.ERROR, consoleLog);
		
		// ADD NOTIFICATION
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