export default class NetworkPingSampler {
  constructor() {
    this.lastClientTime = 0;
    this.ping = 0;
    this.timeoutThreshold = 3000; // === 3s
    this.timeoutTimer = 0;
  }

  update(passedTickTime) {
    let isUpdated = true;
    // Patched on check ping sample timeout
    this.timeoutTimer += passedTickTime;
    return isUpdated;
  }

  processPingSample(clientTime) {
    if (this.lastClientTime > 0) {
      this.ping = clientTime - this.lastClientTime - 1000; // 1000ms (ping interval)
    }
    this.lastClientTime = clientTime;
    // Reset timeout timer
    this.timeoutTimer = 0;
  }

  isTimedOut() {
    return this.timeoutTimer >= this.timeoutThreshold;
  }
}
