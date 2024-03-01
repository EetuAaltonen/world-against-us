function ConsoleHandler() constructor
{
	console_logs = ds_list_create();
	console_logs_limit = 70;
	
	console_log_info_count = 0;
	console_log_warning_count = 0;
	console_log_error_count = 0;
	
	static OnDestroy = function()
	{
		DestroyDSListAndDeleteValues(console_logs);
		console_logs = undefined;
		
		console_log_info_count = 0;
		console_log_warning_count = 0;
		console_log_error_count = 0;
	}
	
	static AddConsoleLog = function(_consoleLogType, _consoleLogMessage)
	{
		var formatMonth = current_month < 10 ? string("0{0}", current_month) : current_month;
		var formatDay = current_day < 10 ? string("0{0}", current_day) : current_day;
		var formatHour = current_hour < 10 ? string("0{0}", current_hour) : current_hour;
		var formatMinute = current_minute < 10 ? string("0{0}", current_minute) : current_minute;
		var formatSecond = current_second < 10 ? string("0{0}", current_second) : current_second;

		var timestampMessage = string("{0}-{1}-{2} {3}:{4}:{5} {6}", current_year, formatMonth, formatDay, formatHour, formatMinute, formatSecond, _consoleLogMessage)
		var consoleLog = new ConsoleLog(_consoleLogType, timestampMessage);
		var consoleMessageCount = ds_list_size(console_logs);
		var messageOverflowCount = max(0, (consoleMessageCount + 1) - console_logs_limit);
		repeat(messageOverflowCount)
		{
			var priorConsoleLog = console_logs[| 0];
			if (!is_undefined(priorConsoleLog))
			{
				switch(priorConsoleLog.console_log_type)
				{
					case CONSOLE_LOG_TYPE.INFO: { console_log_info_count--; } break;
					case CONSOLE_LOG_TYPE.WARNING: { console_log_warning_count--; } break;
					case CONSOLE_LOG_TYPE.ERROR: { console_log_error_count--; } break;
				}
				DeleteDSListValueByIndex(console_logs, 0);
			}
		}
		switch(consoleLog.console_log_type)
		{
			case CONSOLE_LOG_TYPE.INFO: { console_log_info_count++; } break;
			case CONSOLE_LOG_TYPE.WARNING: { console_log_warning_count++; } break;
			case CONSOLE_LOG_TYPE.ERROR: { console_log_error_count++; } break;
		}
		ds_list_add(console_logs, consoleLog);
		
		var currentGUIState = global.GUIStateHandlerRef.GetGUIState();
		if (currentGUIState.index == GUI_STATE.Console)
		{
			var consoleWindow = global.GameWindowHandlerRef.GetWindowById(GAME_WINDOW.Console);
			if (!is_undefined(consoleWindow))
			{
				var consoleLogListElement = consoleWindow.GetChildElementById("ConsoleLogList");
				if (!is_undefined(consoleLogListElement))
				{
					var consoleMessages = ds_list_create();
					ds_list_copy(consoleMessages, global.ConsoleHandlerRef.console_logs);
					consoleLogListElement.UpdateDataCollection(consoleMessages);
				}
			}
		}
	}
	
	static GetAllConsoleLogCount = function()
	{
		return ds_list_size(console_logs);
	}
	
	static GetConsoleLogInfoCount = function()
	{
		return console_log_info_count;
	}
	
	static GetConsoleLogWarningCount = function()
	{
		return console_log_warning_count;
	}
	
	static GetConsoleLogErrorCount = function()
	{
		return console_log_error_count;
	}
	
	static GetConsoleTextColor = function(_consoleLogType)
	{
		var textColor = c_purple; // DEFAULT MISSING COLOR
		switch(_consoleLogType)
		{
			case CONSOLE_LOG_TYPE.INFO: { textColor = c_white } break;
			case CONSOLE_LOG_TYPE.WARNING: { textColor = c_orange } break;
			case CONSOLE_LOG_TYPE.ERROR: { textColor = c_red } break;
		}
		return textColor;
	}
}