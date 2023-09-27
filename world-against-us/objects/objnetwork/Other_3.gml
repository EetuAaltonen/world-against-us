if (networkHandler.network_status != NETWORK_STATUS.OFFLINE)
{
	if (networkHandler.client_id != UNDEFINED_UUID)
	{
		networkHandler.DisconnectSocket();
	}
}