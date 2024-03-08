function FindInstanceNetwork(_networkId, _objectIndex = all)
{
	var foundInstance = noone;
	with (_objectIndex)
	{
		if (networkId == _networkId)
		{
			foundInstance = id;
		}
	}
	return foundInstance;
}