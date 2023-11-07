import WEATHER_CONDITION from "./WeatherCondition.js";

import WorldStateDateTime from "./WorldStateDateTime.js";

export default class WorldStateHandler {
  constructor(networkHandler) {
    this.networkHandler = networkHandler;
    this.dateTime = new WorldStateDateTime(this);
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

  rollWeather() {
    let isWeatherRolled = false;
    const keys = Object.keys(WEATHER_CONDITION);
    const randomKey = keys[(keys.length * Math.random()) << 0];
    const newWeatherCondition = WEATHER_CONDITION[randomKey];
    if (this.weather != newWeatherCondition) {
      this.weather = newWeatherCondition;
      isWeatherRolled = this.networkHandler.broadcastWeather(this.weather);
    } else {
      isWeatherRolled = true;
    }
    return isWeatherRolled;
  }
}
