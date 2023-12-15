export default class NetworkPingSample {
  constructor(clientTime, serverTime) {
    this.clientTime = clientTime;
    this.serverTime = serverTime;
    this.timeoutThreshold = 3000; // === 3s
    this.timeoutTimer = 0;
  }

  update(passedTickTime) {
    let isUpdated = true;
    // Patched on check ping sample timeout
    this.timeoutTimer += passedTickTime;
    return isUpdated;
  }

  isTimedOut() {
    return this.timeoutTimer >= this.timeoutThreshold;
  }

  reset() {
    this.clientTime = 0;
    this.serverTime = 0;
    this.timeoutTimer = 0;
  }
}
