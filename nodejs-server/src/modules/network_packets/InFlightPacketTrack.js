import MESSAGE_TYPE from "../network/MessageType.js";

import ConsoleHandler from "../console/ConsoleHandler.js";

export default class InFlightPacketTrack {
  constructor() {
    this.inFlightPackets = [];
    this.outgoingSequenceNumber = -1;
    this.maxSequenceNumber = 255;
    this.expectedSequenceNumber = 0;
    this.pendingAckRange = [];
    this.droppedPacketCount = 0;
  }

  patchSequenceNumber(networkPacket, inFlightPacketTrack) {
    let isSequenceNumberPatched = true;
    if (++this.outgoingSequenceNumber > this.maxSequenceNumber) {
      this.outgoingSequenceNumber = 0;
    }
    networkPacket.header.sequenceNumber = this.outgoingSequenceNumber;
    if (inFlightPacketTrack) {
    }
    return isSequenceNumberPatched;
  }

  patchAckRange(networkPacket) {
    let isAcknowledgmentIdPatched = true;
    if (this.pendingAckRange.length > 0) {
      // Patch ACK range values
      networkPacket.header.ackCount = this.pendingAckRange.length;
      networkPacket.header.ackRange = this.pendingAckRange.slice();
      // Clear pending ack range
      this.pendingAckRange = [];
    } else {
      if (networkPacket.header.message_type === MESSAGE_TYPE.ACKNOWLEDGMENT) {
        ConsoleHandler.Log("Unnecessary MESSAGE_TYPE.ACKNOWLEDGMENT dropped");
        // Reverse outgoing sequence number
        if (--this.outgoingSequenceNumber < 0) {
          this.outgoingSequenceNumber = this.maxSequenceNumber;
        }
        isAcknowledgmentIdPatched = false;
      }
    }
    return isAcknowledgmentIdPatched;
  }

  addNetworkPacket(networkPacket) {
    let isPacketAdded = true;
    this.inFlightPackets.push(networkPacket);
    return isPacketAdded;
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

  clearTrackedInFlightPackets() {
    this.inFlightPackets = [];
    this.pendingAckRange = [];
  }

  removeTrackedInFlightPacket(sequenceNumber) {
    let isPacketDropped = false;
    const inFlightPacketCount = this.inFlightPackets.length;
    for (let i = 0; i < inFlightPacketCount; i++) {
      const inFlightPacket = this.inFlightPackets[i];
      if (inFlightPacket !== undefined) {
        if (inFlightPacket.header.sequenceNumber === sequenceNumber) {
          this.inFlightPackets.splice(i, 1);
          isPacketDropped = true;
          break;
        }
      }
    }
    return isPacketDropped;
  }
}
