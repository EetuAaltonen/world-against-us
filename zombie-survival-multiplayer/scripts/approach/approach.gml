/// Approach(a, b, amount)
// Moves "a" towards "b" by "amount" and returns the result
// Nice bcause it will not overshoot "b", and works in both directions

function Approach(_value, _target, _step)
{
	if (_value < _target)
	{
	    _value += _step;
	    if (_value > _target)
	        return _target;
	}
	else
	{
	    _value -= _step;
	    if (_value < _target)
	        return _target;
	}
	return _value;
}
