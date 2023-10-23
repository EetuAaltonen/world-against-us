export default class NetworkPacketHeader {
  constructor(messageType, clientId, acknowledgmentId) {
    this.messageType = messageType;
    this.clientId = clientId;
    this.acknowledgmentId = acknowledgmentId;
  }
}
