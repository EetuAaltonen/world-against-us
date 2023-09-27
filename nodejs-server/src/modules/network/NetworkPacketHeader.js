export default class NetworkPacketHeader {
  constructor(messageType, clientId) {
    this.messageType = messageType;
    this.clientId = clientId;
  }
}
