function WorldStateDateTime() constructor
{
	year = 0;
    month = 0; // Constant 30 days
    day = 0;
    hours = 0;
    minutes = 0;
    seconds = 0;
    milliseconds = 0;

    // 24 in-game hours is 1 real-life hour
	base_time_scale = 24;
    time_scale = base_time_scale;
	
	static Update = function()
	{
		var isTimeUpdated = true;
		time_scale = (global.DEBUGMODE && !global.MultiplayerMode) ? 1000 : base_time_scale;
	    milliseconds += (delta_time * 0.001) * time_scale;
	    if (milliseconds >= 1000) {
	      seconds += floor(milliseconds / 1000);
	      milliseconds = milliseconds % 1000;
	      if (seconds >= 60) {
	        minutes += floor(seconds / 60);
	        seconds = seconds % 60;
	        if (minutes >= 60) {
	          hours += floor(minutes / 60);
	          minutes = minutes % 60;
	          if (hours >= 24) {
	            day += floor(hours / 24);
	            hours = hours % 24;
	            if (day >= 30) {
	              month += floor(day / 30);
	              day = day % 30;
	              if (month >= 12) {
	                year += floor(month / 12);
	                month = month % 12;
	              }
	            }
	          }
	        }
	      }
	    }
		return isTimeUpdated;
	}
	
	static TimeToString = function()
	{
		return string_replace_all(string(
			"{0}:{1}:{2}",
			string_format(hours, 2, 0),
			string_format(minutes, 2, 0),
			string_format(seconds, 2, 0)
		), " ", "0");
	}
	
	static DateToString = function()
	{
		return string("{0} year {1} month {2} day", year, month, day);
	}
}