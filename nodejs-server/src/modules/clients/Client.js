export default class Client {
  constructor(uuid, address, port, playerTag) {
    this.uuid = uuid;
    this.address = address;
    this.port = port;
    this.playerTag = playerTag;
    this.instanceId = undefined;

    this.priorityPacketQueue = [];
    this.packetQueue = [];
  }

  getPacketToSend() {
    let networkPacket = undefined;
    // Check priority packet queue
    if (this.priorityPacketQueue.length > 0) {
      // Fetch priority network packet
      networkPacket = this.priorityPacketQueue.shift();
    } else {
      // Check packet queue
      if (this.packetQueue.length > 0) {
        // Fetch network packet
        networkPacket = this.packetQueue.shift();
        // Send rate timer is restarted after packet is successfully sent
      }
    }
    return networkPacket;
  }

  clearPacketQueue() {
    this.priorityPacketQueue = [];
    this.packetQueue = [];
  }

  setInstanceId(instanceId) {
    this.instanceId = instanceId;
  }

  resetInstanceId() {
    this.instanceId = undefined;
  }
}
