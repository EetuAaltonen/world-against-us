export default class Client {
  constructor(uuid, address, port) {
    this.uuid = uuid;
    this.address = address;
    this.port = port;
    this.instanceId = undefined;
  }

  setInstanceId(instanceId) {
    this.instanceId = instanceId;
  }

  resetInstanceId() {
    this.instanceId = undefined;
  }
}
