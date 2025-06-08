/// @function		Approach(_value, _target, _step)
/// @description	Moves value towards target
///					and returns ther result
///					Prevents overshoot the target,
///					and works in both directions
/// @param	{number} _value
/// @param	{number} _target
/// @param	{number} _step
/// @return {number}
function Approach(_value, _target, _step)
{
	if (_value < _target)
	{
		_value += _step;
		if (_value > _target) return _target;
	} else {
		_value -= _step;
		if (_value < _target) return _target;
	}
	return _value;
}
