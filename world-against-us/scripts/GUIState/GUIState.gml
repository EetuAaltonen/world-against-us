function GUIState(_index, _view, _action, _windowGroup, _chainRule = GUI_CHAIN_RULE.Append, _callback_input_function = undefined, _alternate_close_key = undefined) constructor
{
	index = _index;
	view = _view;
	action = _action;
	windowGroup = _windowGroup;
	chainRule = _chainRule;
	callback_input_function = _callback_input_function;
	alternate_close_key = _alternate_close_key;
	
	static CallbackInputFunction = function()
	{
		if (!is_undefined(callback_input_function))
		{
			if (script_exists(callback_input_function))
			{
				script_execute(callback_input_function);
			} else {
				show_debug_message(string("CallbackInputFunction {0} not found", callback_input_function));
			}
		}
	}
	
	static IsKeyReleasedAlternateGUIStateClose = function()
	{
		var isCloseKeyReleased = false;
		if (!is_undefined(alternate_close_key))
		{
			isCloseKeyReleased = keyboard_check_released(alternate_close_key);
		}
		return isCloseKeyReleased;
	}
	
	static Clone = function()
	{
		return new GUIState(
			index,
			view,
			action,
			windowGroup,
			chainRule,
			callback_input_function,
			alternate_close_key
		);
	}
}