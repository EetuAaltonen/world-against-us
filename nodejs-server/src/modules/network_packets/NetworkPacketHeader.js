export default class NetworkPacketHeader {
  constructor(messageType, clientId) {
    this.messageType = messageType;
    this.clientId = clientId;
    this.sequenceNumber = -1;
    this.acknowledgmentId = -1;
  }
}
