function AckTimeoutFuncResend(_networkPacket)
{
	global.NetworkHandlerRef.ResendNetworkPacket(_networkPacket);
}