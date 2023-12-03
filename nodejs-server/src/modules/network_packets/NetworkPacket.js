export default class NetworkPacket {
  constructor(header, payload, priority) {
    this.header = header;
    this.payload = payload;
    this.priority = priority;
    this.maxAcknowledgmentAttempt = 2;
    this.acknowledgmentAttempt = 1;
    this.acknowledgmentTimeout = 3000; // == 3s
    this.timeoutTimer = this.acknowledgmentTimeout;
  }

  update(passedTickTime) {
    if (!isTimedOut()) {
      this.timeoutTimer -= max(0, passedTickTime);
    }
  }

  // TODO: Add with acknowledgment attempts
  restartTimeOutTimer() {
    this.timeoutTimer = this.acknowledgmentTimeout;
  }

  isTimedOut() {
    return this.timeoutTimer <= 0;
  }
}
