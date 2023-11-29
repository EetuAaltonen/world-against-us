import MESSAGE_TYPE from "../network/MessageType.js";

export default class InFlightPacketTrack {
  constructor() {
    this.inFlightPackets = [];
    this.outgoingSequenceNumber = -1;
    this.maxSequenceNumber = 127;
    this.expectedSequenceNumber = 0;
    // TODO: Add pending acknowledgment logic
    this.pendingAcknowledgments = [];
    this.droppedPacketCount = 0;
  }

  patchNetworkPacketSequenceNumber(networkPacket) {
    let isSequenceNumberPatched = true;
    if (++this.outgoingSequenceNumber > this.maxSequenceNumber) {
      this.outgoingSequenceNumber = 0;
    }
    networkPacket.header.sequenceNumber = this.outgoingSequenceNumber;
    if (networkPacket.header.messageType !== MESSAGE_TYPE.ACKNOWLEDGMENT) {
      this.inFlightPackets.push(networkPacket);
    }
    return isSequenceNumberPatched;
  }

  patchAcknowledgmentId(networkPacket) {
    let isAcknowledgmentIdPatched = true;
    if (this.pendingAcknowledgments.length > 0) {
      networkPacket.header.acknowledgmentId = this.pendingAcknowledgments[0];
      this.pendingAcknowledgments.splice(0, 1);
      if (this.pendingAcknowledgments.length > 0) {
        console.log("ACKNOWLEDGMENTs lagging behind");
      }
    } else {
      if (networkPacket.header.message_type == MESSAGE_TYPE.ACKNOWLEDGMENT) {
        console.log("Useless MESSAGE_TYPE.ACKNOWLEDGMENT sent");
      }
    }
    return isAcknowledgmentIdPatched;
  }

  getInFlightPacket(sequenceNumber) {
    let inFlightPacket = undefined;
    const inFlightPacketCount = this.getInFlightPacketCount();
    for (let i = 0; i < inFlightPacketCount; i++) {
      const networkPacket = this.inFlightPackets[i];
      if (networkPacket !== undefined) {
        if (networkPacket.header.sequenceNumber === sequenceNumber) {
          inFlightPacket = networkPacket;
          break;
        }
      }
    }
    return inFlightPacket;
  }

  getInFlightPacketCount() {
    return this.inFlightPackets.length;
  }

  removeTrackedInFlightPacket(sequenceNumber) {
    let isPacketDropped = false;
    const inFlightPacketCount = this.inFlightPackets.length;
    for (let i = 0; i < inFlightPacketCount; i++) {
      const inFlightPacket = this.inFlightPackets[i];
      if (inFlightPacket !== undefined) {
        if (inFlightPacket.header.sequenceNumber == sequenceNumber) {
          this.inFlightPackets.splice(i, 1);
          isPacketDropped = true;
          break;
        }
      }
    }
    return isPacketDropped;
  }
}
