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

  toJSONStruct() {
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
    if (this.milliseconds >= 1000) {
      this.seconds += Math.floor(this.milliseconds / 1000);
      this.milliseconds = this.milliseconds % 1000;
      if (this.seconds >= 60) {
        this.minutes += Math.floor(this.seconds / 60);
        this.seconds = this.seconds % 60;
        if (this.minutes >= 60) {
          this.hours += Math.floor(this.minutes / 60);
          this.minutes = this.minutes % 60;
          // Roll weather
          isTimeUpdated = this.worldStateHandler.rollWeather();
          if (this.hours >= 24) {
            this.day += Math.floor(this.hours / 24);
            this.hours = this.hours % 24;
            if (this.day >= 30) {
              this.month += Math.floor(this.day / 30);
              this.day = this.day % 30;
              if (this.month >= 12) {
                this.year += Math.floor(this.month / 12);
                this.month = this.month % 12;
              }
            }
          }
        }
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
