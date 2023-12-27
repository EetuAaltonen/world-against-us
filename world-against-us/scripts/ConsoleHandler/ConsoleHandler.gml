function ConsoleHandler() constructor
{
	console_logs = ds_list_create();
	console_logs_limit = 20;
	
	static OnDestroy = function()
	{
		DestroyDSListAndDeleteValues(console_logs);
		console_logs = undefined;
	}
	
	static AddConsoleLog = function(_consoleLogType, _consoleLogMessage)
	{
		var timestampMessage = string("{0}-{1}-{2} {3}:{4}:{5} [{6}] {7}", current_year, current_month, current_day, current_hour, current_minute, current_second, _consoleLogType, _consoleLogMessage)
		var consoleLog = new ConsoleLog(_consoleLogType, timestampMessage);
		var consoleMessageCount = ds_list_size(console_logs);
		var messageOverflowCount = max(0, consoleMessageCount - (console_logs_limit + 1));
		repeat(messageOverflowCount)
		{
			DeleteDSListValueByIndex(console_logs, 0);	
		}
		ds_list_add(console_logs, consoleLog);
	}
	
	static GetConsoleLogCount = function()
	{
		return ds_list_size(console_logs);
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