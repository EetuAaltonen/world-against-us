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
    time_scale = 1; //24;
	
	static Update = function()
	{
		var isTimeUpdated = true;
		milliseconds += (delta_time * 0.001) * time_scale;
		while (floor(milliseconds) >= 1000) {
	      milliseconds -= 1000;
	      seconds++;
	      while (floor(seconds) >= 60) {
	        seconds -= 60;
	        minutes++;
	        while (floor(minutes) >= 60) {
	          minutes -= 60;
	          hours++;
	          while (floor(hours) >= 24) {
	            hours -= 24;
	            day++;
	            while (floor(day) >= 30) {
	              day -= 30;
	              month++;
	              while (floor(month) >= 12) {
	                month -= 12;
	                year++;
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