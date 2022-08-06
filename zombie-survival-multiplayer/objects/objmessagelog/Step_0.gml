var messageCount = ds_list_size(messages);
if (messageCount > 0)
{
	if (displayTimer-- <= 0)
	{
		ds_list_delete(messages, 0);
		displayTimer = displayDuration;
	}
}
