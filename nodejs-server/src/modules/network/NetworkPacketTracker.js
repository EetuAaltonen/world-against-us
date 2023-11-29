import MESSAGE_TYPE from "./MessageType.js";
import InFlightPacketTrack from "../network_packets/InFlightPacketTrack.js";

const UNDEFINED_UUID = "nuuuuuuu-uuuu-uuuu-uuuu-ullundefined";

export default class NetworkPacketTracker {
  constructor(networkHandler) {
    this.networkHandler = networkHandler;
    this.inFlightPacketTracks = {};
  }

  update(passedTickTime) {
    let isUpdated = false;
    const inFlightPacketTrackIds = this.getInFlightPacketTrackIds();
    inFlightPacketTrackIds.forEach((clientId) => {
      const inFlightPacketTrack = this.getInFlightPacketTrack(clientId);
      if (inFlightPacketTrack !== undefined) {
        inFlightPacketTrack.inFlightPackets.forEach((networkPacket) => {
          if (networkPacket !== undefined) {
            networkPacket.timeoutTimer -= passedTickTime;
            if (networkPacket.timeoutTimer <= 0) {
              console.log(
                `Acknowledgment with message type ${networkPacket.header.messageType} and sequence number ${networkPacket.header.sequenceNumber} timed out`
              );
              this.handleTimedOutAcknowledgment(
                inFlightPacketTrack,
                networkPacket.header.sequenceNumber
              );
            }
          }
        });
      }
    });
    isUpdated = true;
    return isUpdated;
  }

  processSequenceNumber(sequenceNumber, clientId, messageType) {
    let isSequenceNumberProcessed = false;
    if (clientId !== UNDEFINED_UUID) {
      const inFlightPacketTrack = this.getInFlightPacketTrack(clientId);
      if (inFlightPacketTrack !== undefined) {
        if (sequenceNumber == inFlightPacketTrack.expectedSequenceNumber) {
          // Successfully received the expected
          inFlightPacketTrack.expectedSequenceNumber = sequenceNumber + 1;
          if (messageType !== MESSAGE_TYPE.ACKNOWLEDGMENT) {
            inFlightPacketTrack.pendingAcknowledgments.push(sequenceNumber);
          }
          isSequenceNumberProcessed = true;
        } else if (
          sequenceNumber > inFlightPacketTrack.expectedSequenceNumber
        ) {
          // Patch to past one of most recent
          console.log(
            `Received sequence number ${sequenceNumber} greater than expected ${inFlightPacketTrack.expectedSequenceNumber}`
          );
          inFlightPacketTrack.expectedSequenceNumber = sequenceNumber + 1;
          if (messageType !== MESSAGE_TYPE.ACKNOWLEDGMENT) {
            inFlightPacketTrack.pendingAcknowledgments.push(sequenceNumber);
          }
          isSequenceNumberProcessed = true;
        } else if (
          sequenceNumber < inFlightPacketTrack.expectedSequenceNumber
        ) {
          // Drop stale data
          console.log(
            `Received sequence number ${sequenceNumber} smaller than expected ${inFlightPacketTrack.expectedSequenceNumber}`
          );
          isSequenceNumberProcessed = false;
        }
        if (
          inFlightPacketTrack.expectedSequenceNumber >
          inFlightPacketTrack.maxSequenceNumber
        ) {
          inFlightPacketTrack.expectedSequenceNumber = 0;
        }
      }
    }
    return isSequenceNumberProcessed;
  }

  processAcknowledgment(acknowledgmentId, clientId) {
    var isAcknowledgmentProceed = false;
    if (clientId !== UNDEFINED_UUID) {
      if (acknowledgmentId > -1) {
        const inFlightPacketTrack = this.getInFlightPacketTrack(clientId);
        if (inFlightPacketTrack !== undefined) {
          inFlightPacketTrack.removeTrackedInFlightPacket(acknowledgmentId);
        }
      }
      isAcknowledgmentProceed = true;
    }
    return isAcknowledgmentProceed;
  }

  addInFlightPacketTrack(clientId) {
    return (this.inFlightPacketTracks[clientId] = new InFlightPacketTrack());
  }

  getInFlightPacketTrack(clientId) {
    return this.inFlightPacketTracks[clientId];
  }

  getInFlightPacketTrackIds() {
    return Object.keys(this.inFlightPacketTracks);
  }

  removeInFlightPacketTrack(clientId) {
    delete this.inFlightPacketTracks[clientId];
  }

  handleTimedOutAcknowledgment(inFlightPacketTrack, sequenceNumber) {
    // TODO: Safety mechanism for dropped packets?
    if (inFlightPacketTrack.removeTrackedInFlightPacket(sequenceNumber)) {
      console.log(
        `Network packet with sequence number ${sequenceNumber} dropped`
      );
    }
  }
}
