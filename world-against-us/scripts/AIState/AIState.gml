function AIState(_index, _updateFunc) constructor
{
	index = _index;
	update_func = _updateFunc;
	
	static Update = function(_aiBase)
	{
		return update_func(_aiBase);
	}
}