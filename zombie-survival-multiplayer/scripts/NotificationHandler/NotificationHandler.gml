function NotificationHandler() constructor
{
	notifications = ds_list_create();
	animationCurve = new AnimationCurve(animNotification, "curveNotificationSlideIn", 2);
	
	static AddNotification = function(_notification)
	{
		ds_list_add(notifications, _notification);
	}
	
	static Update = function()
	{
		var notificationCount = ds_list_size(notifications);
		if (notificationCount > 0)
		{
			if (animationCurve.IsEnded())
			{
				if (!animationCurve.isReversed)
				{
					animationCurve.PlayReversed();
				} else {
					animationCurve.Reset();
					ds_list_delete(notifications, 0);
				}
			} else {
				if (animationCurve.isPlaying)
				{
					animationCurve.Update();
				} else {
					animationCurve.Play();
				}
			}
		}
	}
	
	static ClearNotifications = function()
	{
		ds_list_clear(notifications);
	}
	
	static Draw = function()
	{
		var notificationCount = ds_list_size(notifications);
		if (notificationCount > 0)
		{
			var notification = notifications[| 0];
			var animationPosition = animationCurve.GetValue();
			
			draw_set_halign(fa_left);
			draw_set_valign(fa_middle);
			draw_set_font(font_default);
				
			var notificationBoxSize = new Size (600, 160);
			var notificationBoxBasePos = new Vector2(global.GUIW, 150);
			var notificationBoxPos = new Vector2(
				notificationBoxBasePos.X - (notificationBoxSize.w * animationPosition),
				notificationBoxBasePos.Y,
			);
			var notificationIconSize = new Size(128, 128);
			var notificationIconScale = ScaleSpriteToFitSize(notification.icon, notificationIconSize);
			
			// NOTIFICATION BACKGROUND
			draw_sprite_ext(
				sprGUIBg, 0, notificationBoxPos.X, notificationBoxPos.Y,
				notificationBoxSize.w, notificationBoxSize.h, 0, #c1db4b, 1
			);
			// NOTIFICATION ICON
			draw_sprite_ext(
				notification.icon, 0,
				notificationBoxPos.X + 20 + (notificationIconSize.w * 0.5),
				notificationBoxPos.Y + (notificationBoxSize.h * 0.5),
				notificationIconScale, notificationIconScale, 0, c_white, 1
			)
			// NOTIFICATION TITLE
			draw_text(notificationBoxPos.X + 200, notificationBoxPos.Y + 30, string("{0}", notification.title));
			// NOTIFICATION DESCRIPTION
			draw_set_font(font_small);
			draw_text(notificationBoxPos.X + 200, notificationBoxPos.Y + 60, string("{0}", notification.description));
				
			// RESET DRAW PROPERTIES
			ResetDrawProperties();
		}
	}
}