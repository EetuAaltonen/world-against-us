function ValidateMultiplayerConnectionDetails(_playerTagInputElement, _addressInputElement, _portInputElement)
{
	var isDetailsValid = true;
	// VALIDATE PLAYER TAG
	if (_playerTagInputElement.input != _playerTagInputElement.placeholder)
	{
		if (string_length(_playerTagInputElement.input) < MIN_PLAYER_TAG_LENGTH)
		{
			isDetailsValid = false;
			var notificationText = string(
				"Player tag is too short (min {0}), please try another",
				MIN_PLAYER_TAG_LENGTH
			);
			global.NotificationHandlerRef.AddNotification(
				new Notification(
					undefined,
					notificationText,
					undefined,
					NOTIFICATION_TYPE.Log
				)
			);
		} else if (string_length(_playerTagInputElement.input) > MAX_PLAYER_TAG_LENGTH)
		{
			isDetailsValid = false;
			var notificationText = string(
				"Player tag is too long (max {0}), please try another",
				MAX_PLAYER_TAG_LENGTH
			);
			global.NotificationHandlerRef.AddNotification(
				new Notification(
					undefined,
					notificationText,
					undefined,
					NOTIFICATION_TYPE.Log
				)
			);
		}
	} else {
		isDetailsValid = false;
		global.NotificationHandlerRef.AddNotification(
			new Notification(
				undefined,
				"Player tag is empty, please try another",
				undefined,
				NOTIFICATION_TYPE.Log
			)
		);
	}
	
	// VALIDATE ADDRESS
	if (_addressInputElement.input == _addressInputElement.placeholder)
	{
		isDetailsValid = false;
		global.NotificationHandlerRef.AddNotification(
			new Notification(
				undefined,
				"Server address is empty, please try another",
				undefined,
				NOTIFICATION_TYPE.Log
			)
		);
	}
	
	// VALIDATE PORT
	if (_portInputElement.input != _portInputElement.placeholder)
	{
		try
		{
			// TEST FOR NUMERIC VALUE
			var stringLength = string_length(_portInputElement.input);
			for (var i = 1; i <= stringLength; i++)
			{
				var char = string_char_at(_portInputElement.input, i);
				var charToNumber = real(char);
			}
		} catch (error)
		{
			isDetailsValid = false;
			show_debug_message(error);
			global.NotificationHandlerRef.AddNotification(
				new Notification(
					undefined,
					"Invalid server port, please try another",
					undefined,
					NOTIFICATION_TYPE.Log
				)
			);
		}
	} else {
		isDetailsValid = false;
		global.NotificationHandlerRef.AddNotification(
			new Notification(
				undefined,
				"Server port is empty, please try another",
				undefined,
				NOTIFICATION_TYPE.Log
			)
		);
	}
	return isDetailsValid;
}