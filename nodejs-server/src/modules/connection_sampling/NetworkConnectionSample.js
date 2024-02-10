import ConsoleHandler from "../console/ConsoleHandler.js";
import NetworkPingSampler from "./NetworkPingSampler.js";

export default class NetworkConnectionSample {
  constructor() {
    this.sentRateSampleInterval = 1000; // == 1s
    this.sentRateSampleTimer = 0;
    this.dataSentRate = 0;
    this.pingSampler = new NetworkPingSampler();
  }

  update(passedTickTime) {
    let isUpdated = true;
    this.updateSentRate(passedTickTime);
    this.pingSampler.update(passedTickTime);
    return isUpdated;
  }

  updateSentRate(passedTickTime) {
    let isUpdated = true;
    this.sentRateSampleTimer += passedTickTime;
    if (this.sentRateSampleTimer >= this.sentRateSampleInterval) {
      this.sentRateSampleTimer -= this.sentRateSampleInterval;
      ConsoleHandler.Log(`Data sent ${this.dataSentRate} kb/s`);
      this.dataSentRate = 0;
    }
    return isUpdated;
  }
}
