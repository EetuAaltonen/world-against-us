function NotificationHandler() constructor
{
	// LOG NOTIFICATIONS
	log_notifications = [];
	log_notification_timer = new Timer(2000);
	log_notification_timer.StartTimer();
	
	// POPUP NOTIFICATIONS
	popup_notifications = [];
	popup_animation_curve = new AnimationCurve(animNotification, "curveNotificationSlideIn", 2);
	
	static AddNotification = function(_notification)
	{
		switch (_notification.type)
		{
			case NOTIFICATION_TYPE.Log:
			{
				array_push(log_notifications, _notification);
			} break;
			case NOTIFICATION_TYPE.Popup:
			{
				array_push(popup_notifications, _notification);
			} break;
		}
	}
	
	static AddNotificationPlayerConnected = function(_playerTag)
	{
		AddNotification(
			new Notification(
				sprIconRemoteConnect, "Client connected",
				string("{0} joined the game", _playerTag),
				NOTIFICATION_TYPE.Popup
			)
		);
	}
	
	static AddNotificationPlayerDisconnected = function(_playerTag)
	{
		AddNotification(
			new Notification(
				sprIconRemoteDisconnect, "Client disconnected",
				string("{0} disconnected from the game", _playerTag),
				NOTIFICATION_TYPE.Popup
			)
		);
	}
	
	static AddNotificationPlayerReturnedToCamp = function(_playerTag)
	{
		global.NotificationHandlerRef.AddNotification(
			new Notification(
				sprIconRemoteEnterRegion, "Client returned to Camp",
				string("{0} returned to the Camp", _playerTag),
				NOTIFICATION_TYPE.Popup
			)
		);
	}
	
	static Update = function()
	{
		// PRIORITIZE LOG NOTIFICATIONS
		var logNotificationCount = array_length(log_notifications);
		if (logNotificationCount > 0)
		{
			log_notification_timer.Update();
			if (log_notification_timer.IsTimerStopped())
			{
				array_delete(log_notifications, 0, 1);
				log_notification_timer.StartTimer();
			}
		} else {
			var popupNotificationCount = array_length(popup_notifications);
			if (popupNotificationCount > 0)
			{
				if (popup_animation_curve.IsEnded())
				{
					if (!popup_animation_curve.isReversed)
					{
						popup_animation_curve.PlayReversed();
					} else {
						array_delete(popup_notifications, 0, 1);
						popup_animation_curve.Reset();
					}
				} else {
					if (popup_animation_curve.isPlaying)
					{
						popup_animation_curve.Update();
					} else {
						popup_animation_curve.Play();
					}
				}
			}
		}
	}
	
	static Draw = function()
	{
		// PRIORITIZE LOG NOTIFICATIONS
		var logNotificationCount = array_length(log_notifications);
		if (logNotificationCount > 0)
		{
			var notification = log_notifications[@ 0];
			var textPos = new Vector2(
				(global.GUIW * 0.5),
				(100 * (1 - (log_notification_timer.GetTime() / log_notification_timer.GetSettingTime())))
			);
		
			draw_set_color(c_red);
			draw_set_halign(fa_center);
		
			draw_text(textPos.X, textPos.Y, string(notification.title));
	
			// RESET DRAW PROPERTIES
			ResetDrawProperties();
		} else {
			var popupNotificationCount = array_length(popup_notifications);
			if (popupNotificationCount > 0)
			{
				var notification = popup_notifications[@ 0];
				var animationPosition = popup_animation_curve.GetValue();
			
				draw_set_halign(fa_left);
				draw_set_valign(fa_middle);
				draw_set_font(font_default);
				
				var notificationBoxSize = new Size (600, 160);
				var notificationBoxBasePos = new Vector2(global.GUIW, 150);
				var notificationBoxPos = new Vector2(
					notificationBoxBasePos.X - (notificationBoxSize.w * animationPosition),
					notificationBoxBasePos.Y,
				);
				var iconSize = new Size(128, 128);
				var iconScale = ScaleSpriteToFitSize(notification.icon, iconSize);
				var iconPosOffset = new Vector2(
					sprite_get_xoffset(notification.icon) * iconScale,
					sprite_get_yoffset(notification.icon) * iconScale
				);
			
				// NOTIFICATION BACKGROUN
				draw_sprite_ext(
					sprGUIBg, 0, notificationBoxPos.X, notificationBoxPos.Y,
					notificationBoxSize.w, notificationBoxSize.h, 0, #c1db4b, 1
				);
				// NOTIFICATION ICON
				draw_sprite_ext(
					notification.icon, 0,
					notificationBoxPos.X + 20 + iconPosOffset.X,
					notificationBoxPos.Y + (notificationBoxSize.h * 0.5) - (iconSize.h * 0.5) + iconPosOffset.Y,
					iconScale, iconScale, 0, c_white, 1
				)
				// NOTIFICATION TITLE
				draw_text(notificationBoxPos.X + 200, notificationBoxPos.Y + 30, string("{0}", notification.title ?? EMPTY_STRING));
				// NOTIFICATION DESCRIPTION
				draw_set_font(font_small);
				draw_text(notificationBoxPos.X + 200, notificationBoxPos.Y + 60, string("{0}", notification.description ?? EMPTY_STRING));
				
				// RESET DRAW PROPERTIES
				ResetDrawProperties();
			}
		}
	}
}