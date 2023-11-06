export default class WorldStateDateTime {
  constructor() {
    this.year = 0;
    this.month = 0; // Constant 30 days
    this.day = 0;
    this.hours = 0;
    this.minutes = 0;
    this.seconds = 0;
    this.milliseconds = 0;

    // 24 in-game hours is 1 real-life hour
    this.time_scale = 24;
  }

  update(passedTickTime) {
    let isTimeUpdated = true;
    this.milliseconds += passedTickTime * this.time_scale;
    while (Math.floor(this.milliseconds) >= 1000) {
      this.milliseconds -= 1000;
      this.seconds++;
      while (Math.floor(this.seconds) >= 60) {
        this.seconds -= 60;
        this.minutes++;
        while (Math.floor(this.minutes) >= 60) {
          this.minutes -= 60;
          this.hours++;
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
