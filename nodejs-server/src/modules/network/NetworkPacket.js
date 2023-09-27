export default class NetworkPacket {
  constructor(header, payload) {
    this.header = header;
    this.payload = payload;
  }
}
