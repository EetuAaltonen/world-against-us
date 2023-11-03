function Size(_w, _h) constructor
{
	w = _w;
	h = _h;
	
	static ToJSONStruct = function()
	{
		return {
			w: w,
			h: h
		}
	}
	
	static Clone = function()
	{
		return new Size(w, h);
	}
	
	static Swap = function()
	{
		var tempWidth = w;
		w = h;
		h = tempWidth;
	}
}