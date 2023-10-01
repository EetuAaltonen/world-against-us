export default class NetworkPacket {
  constructor(header, payload, priority) {
    this.header = header;
    this.payload = payload;
    this.priority = priority;
  }
}
