if (async_load[? "size"] > 0)
{
	var networkBuffer = async_load[? "buffer"];
	networkHandler.HandleMessage(networkBuffer);
}