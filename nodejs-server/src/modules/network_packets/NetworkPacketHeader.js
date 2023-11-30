export default class NetworkPacketHeader {
  constructor(messageType, clientId) {
    this.messageType = messageType;
    this.clientId = clientId;
    this.sequenceNumber = 0;
    this.ackCount = 0;
    this.ackRange = [];
  }
}
