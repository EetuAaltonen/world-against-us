function AddMessageLog(_message) {
	if (!is_undefined(global.MessageLog))
	{
		ds_list_add(global.MessageLog, _message);
	}
}