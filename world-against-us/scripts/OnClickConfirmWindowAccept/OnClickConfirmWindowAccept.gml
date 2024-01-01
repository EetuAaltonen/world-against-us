function OnClickConfirmWindowAccept()
{
	if (!is_undefined(metadata))
	{
		// FETCH METADATA FROM CALLER BUTTON
		// EXECUTE CONFIRM CALLBACK FUNCTION
		metadata.confirmCallbackFunction(metadata.callerWindowElement);
		
		// CLOSE CONFIRM WINDOW
		global.GUIStateHandlerRef.RequestCloseCurrentGUIState();
	}
}