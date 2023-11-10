export default class WorldStateDateTime {
  constructor(worldStateHandler) {
    this.worldStateHandler = worldStateHandler;
    this.year = 0;
    this.month = 0; // Constant 30 days
    this.day = 0;
    this.hours = 0;
    this.minutes = 0;
    this.seconds = 0;
    this.milliseconds = 0;

    // Set start to Day 1, 8:00 o'clock
    this.defaultDay = 1;
    this.defaultHours = 8;
    this.day = this.defaultDay;
    this.hours = this.defaultHours;

    // 24 in-game hours is 1 real-life hour
    this.defaultTimeScale = 24;
    this.timeScale = this.defaultTimeScale;
  }

  toJSONObject() {
    return {
      year: this.year,
      month: this.month,
      day: this.day,
      hours: this.hours,
      minutes: this.minutes,
      seconds: this.seconds,
      time_scale: this.timeScale,
    };
  }

  update(passedTickTime) {
    let isTimeUpdated = true;
    this.milliseconds += passedTickTime * this.timeScale;
    while (Math.floor(this.milliseconds) >= 1000) {
      this.milliseconds -= 1000;
      this.seconds++;
      while (Math.floor(this.seconds) >= 60) {
        this.seconds -= 60;
        this.minutes++;
        while (Math.floor(this.minutes) >= 60) {
          this.minutes -= 60;
          this.hours++;
          isTimeUpdated = this.worldStateHandler.rollWeather();
          while (Math.floor(this.hours) >= 24) {
            this.hours -= 24;
            this.day++;
            while (Math.floor(this.day) >= 30) {
              this.day -= 30;
              this.month++;
              while (Math.floor(this.month) >= 12) {
                this.month -= 12;
                this.year++;
              }
            }
          }
        }
        // TODO: Console log world time for debugging
        //console.log(this.timeToString());
      }
    }
    return isTimeUpdated;
  }

  timeToString() {
    return `${this.hours}:${this.minutes}:${this.seconds}.${Math.round(
      this.milliseconds
    )}`;
  }

  dateToString() {
    return `${this.year} year ${this.month} month ${this.day} day`;
  }
}
