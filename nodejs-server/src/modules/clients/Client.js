export default class Client {
  constructor(uuid, address, port, playerTag) {
    this.uuid = uuid;
    this.address = address;
    this.port = port;
    this.playerTag = playerTag;
    this.instanceId = undefined;

    this.priorityPacketQueue = [];
    this.packetQueue = [];
    this.packetSendRate = 1000 / 30;
    this.packetSendRateTimer = this.packetSendRate;
  }

  getPacketToSend(passedTickTime) {
    let networkPacket = undefined;

    // Update packet send rate timer
    this.packetSendRateTimer += passedTickTime;

    // Check priority packet queue
    if (this.priorityPacketQueue.length > 0) {
      networkPacket = this.priorityPacketQueue.shift();
    } else {
      // Check packet queue
      if (this.packetQueue.length > 0) {
        // Check send rate timer
        if (this.packetSendRateTimer >= this.packetSendRate) {
          // Reset send rate timer
          this.packetSendRateTimer = 0;
          networkPacket = this.packetQueue.shift();
        }
      }
    }
    return networkPacket;
  }

  setInstanceId(instanceId) {
    this.instanceId = instanceId;
  }

  resetInstanceId() {
    this.instanceId = undefined;
  }
}
