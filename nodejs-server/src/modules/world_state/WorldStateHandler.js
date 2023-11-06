import WorldStateDateTime from "./WorldStateDateTime.js";

export default class WorldStateHandler {
  constructor(networkHandler) {
    this.networkHandler = networkHandler;
    this.dateTime = new WorldStateDateTime();
    // Set start to Day 1, 8:00 o'clock
    this.dateTime.day = 1;
    this.dateTime.hours = 8;
    this.weather = 0;
  }

  update(passedTickTime) {
    let isUpdated = false;
    isUpdated = this.dateTime.update(passedTickTime);
    return isUpdated;
  }
}
