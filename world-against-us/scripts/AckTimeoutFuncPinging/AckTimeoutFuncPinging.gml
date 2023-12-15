function AckTimeoutFuncPinging(_networkPacket)
{
	global.NetworkConnectionSamplerRef.last_data_sent_rate = undefined;
	global.NetworkConnectionSamplerRef.ping = 999;
}