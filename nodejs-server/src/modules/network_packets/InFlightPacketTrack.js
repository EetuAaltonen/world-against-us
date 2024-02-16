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

  patchNetworkPacketAckRange(networkPacket) {
    let isAckRangePatched = false;
    if (networkPacket.deliveryPolicy.patchAckRange) {
      if (this.pendingAckRange.length > 0) {
        // Patch ACK range values
        networkPacket.header.ackCount = this.pendingAckRange.length;
        networkPacket.header.ackRange = this.pendingAckRange.slice();
        isAckRangePatched = true;
      } else {
        if (networkPacket.header.message_type === MESSAGE_TYPE.ACKNOWLEDGMENT) {
          ConsoleHandler.Log("Unnecessary MESSAGE_TYPE.ACKNOWLEDGMENT dropped");
        } else {
          isAckRangePatched = true;
        }
      }
      // Pending ACK range is cleared after packet is successfully sent
    } else {
      // Patch ACK range set to false in delivery policy
      isAckRangePatched = true;
    }
    return isAckRangePatched;
  }

  patchNetworkPacketSequenceNumber(networkPacket) {
    let isSequenceNumberPatched = false;
    if (networkPacket.deliveryPolicy.patchSequenceNumber) {
      if (++this.outgoingSequenceNumber > this.maxSequenceNumber) {
        this.outgoingSequenceNumber = 0;
      }
      networkPacket.header.sequenceNumber = this.outgoingSequenceNumber;
      isSequenceNumberPatched = true;
    } else {
      // Patch sequence number set to false in delivery policy
      isSequenceNumberPatched = true;
    }
    return isSequenceNumberPatched;
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
