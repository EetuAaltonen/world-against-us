function WindowButtonCondition(_elementId, _relativePosition, _size, _backgroundColor, _title, _buttonStyle, _callbackFunction, _metadata = undefined, _conditionFunction = undefined) : WindowButton(_elementId, _relativePosition, _size, _backgroundColor, _title, _buttonStyle, _callbackFunction, _metadata = undefined) constructor
{
	metadata = _metadata;
	conditionFunction = _conditionFunction;
}