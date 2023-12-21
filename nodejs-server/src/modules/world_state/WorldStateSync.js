export default class WorldStateSync {
  constructor(dateTime, weather) {
    this.dateTime = dateTime;
    this.weather = weather;
  }

  toJSONStruct() {
    const formatDateTime = this.dateTime.toJSONStruct();
    return {
      date_time: formatDateTime,
      weather: this.weather,
    };
  }
}
