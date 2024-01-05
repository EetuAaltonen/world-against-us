export default class Client {
  constructor(uuid, address, port, playerTag) {
    this.uuid = uuid;
    this.address = address;
    this.port = port;
    this.playerTag = playerTag;
    this.instanceId = undefined;
  }

  setInstanceId(instanceId) {
    this.instanceId = instanceId;
  }

  resetInstanceId() {
    this.instanceId = undefined;
  }
}
