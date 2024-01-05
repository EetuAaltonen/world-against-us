function AckTimeoutFuncPinging(_networkPacket)
{
	global.NetworkConnectionSamplerRef.last_data_out_rate = 0;
	global.NetworkConnectionSamplerRef.last_data_in_rate = 0;
	global.NetworkConnectionSamplerRef.ping = 999;
}