function ConsoleHandler() constructor
{
	console_messages = ds_list_create();
	console_message_limit = 10;
	
	static OnDestroy = function()
	{
		DestroyDSListAndDeleteValues(console_messages);
		console_messages = undefined;
	}
	
	static AddConsoleLog = function(_consoleLog)
	{
		var consoleMessageCount = ds_list_size(console_messages);
		var messageOverflowCount = max(0, consoleMessageCount - (console_message_limit + 1));
		repeat(messageOverflowCount)
		{
			DeleteDSListValueByIndex(console_messages, 0);	
		}
		ds_list_add(console_messages, _consoleLog);
	}
}