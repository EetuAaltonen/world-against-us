import MESSAGE_TYPE from "./MessageType.js";
import PACKET_PRIORITY from "./PacketPriority.js";

import InFlightPacketTrack from "../network_packets/InFlightPacketTrack.js";
import NetworkQueueEntry from "./NetworkQueueEntry.js";

const UNDEFINED_UUID = "nuuuuuuu-uuuu-uuuu-uuuu-ullundefined";

export default class NetworkPacketTracker {
  constructor(networkHandler, clientHandler) {
    this.networkHandler = networkHandler;
    this.clientHandler = clientHandler;
    this.inFlightPacketTracks = {};
  }

  update(passedTickTime) {
    let isUpdated = false;
    const inFlightPacketTrackIds = this.getInFlightPacketTrackIds();
    inFlightPacketTrackIds.forEach((clientId) => {
      const inFlightPacketTrack = this.getInFlightPacketTrack(clientId);
      if (inFlightPacketTrack !== undefined) {
        inFlightPacketTrack.inFlightPackets.forEach((inFlightPacket) => {
          if (inFlightPacket !== undefined) {
            inFlightPacket.timeoutTimer -= passedTickTime;
            if (inFlightPacket.timeoutTimer <= 0) {
              if (
                inFlightPacket.acknowledgmentAttempt <=
                inFlightPacket.maxAcknowledgmentAttempt
              ) {
                console.log(
                  `Acknowledgment timeout attempt ${inFlightPacket.acknowledgmentAttempt} with message type ${inFlightPacket.header.messageType} and sequence number ${inFlightPacket.header.sequenceNumber} timed out`
                );
                inFlightPacket.acknowledgmentAttempt++;
                inFlightPacket.restartTimeOutTimer();
                const client = this.clientHandler.getClient(clientId);
                if (client !== undefined) {
                  if (
                    !this.resendNetworkPacket(
                      inFlightPacket,
                      inFlightPacketTrack,
                      client
                    )
                  ) {
                    console.log(
                      `Failed to resend in-flight network packet with message type ${inFlightPacket.header.messageType} and sequence number ${inFlightPacket.header.sequenceNumber}`
                    );
                  }
                } else {
                  console.log(
                    `Failed to resend in-flight network packet to undefined client`
                  );
                }
              } else {
                // TODO: Safety mechanism for dropped packets?
                if (
                  inFlightPacketTrack.removeTrackedInFlightPacket(
                    inFlightPacket.header.sequenceNumber
                  )
                ) {
                  console.log(
                    `Acknowledgment with message type ${inFlightPacket.header.messageType} and sequence number ${inFlightPacket.header.sequenceNumber} timed out`
                  );
                }
                const client = this.clientHandler.getClient(clientId);
                if (client !== undefined) {
                  this.networkHandler.disconnectClientWithTimeout(
                    inFlightPacket.header.clientId,
                    client.address,
                    client.port
                  );
                }
              }
            }
          }
        });
      }
    });
    isUpdated = true;
    return isUpdated;
  }

  processAckRange(ackCount, ackRange, clientId) {
    var isAcknowledgmentProceed = false;
    if (clientId !== UNDEFINED_UUID) {
      const inFlightPacketTrack = this.getInFlightPacketTrack(clientId);
      if (inFlightPacketTrack !== undefined) {
        for (let i = 0; i < ackCount; i++) {
          const acknowledgmentId = ackRange[i] ?? 0;
          inFlightPacketTrack.removeTrackedInFlightPacket(acknowledgmentId);
        }
        isAcknowledgmentProceed = true;
      }
    }
    return isAcknowledgmentProceed;
  }

  processSequenceNumber(sequenceNumber, clientId, messageType) {
    let isSequenceNumberProcessed = false;
    if (clientId !== UNDEFINED_UUID) {
      const inFlightPacketTrack = this.getInFlightPacketTrack(clientId);
      if (inFlightPacketTrack !== undefined) {
        if (sequenceNumber === inFlightPacketTrack.expectedSequenceNumber) {
          // Successfully received the expected
          inFlightPacketTrack.expectedSequenceNumber = sequenceNumber + 1;
          if (messageType !== MESSAGE_TYPE.ACKNOWLEDGMENT) {
            inFlightPacketTrack.pendingAckRange.push(sequenceNumber);
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
            inFlightPacketTrack.pendingAckRange.push(sequenceNumber);
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

  resendNetworkPacket(inFlightPacket, inFlightPacketTrack, client) {
    var isPacketResend = false;
    if (
      inFlightPacketTrack.removeTrackedInFlightPacket(
        inFlightPacket.header.sequenceNumber
      )
    ) {
      inFlightPacket.priority = PACKET_PRIORITY.CRITICAL;
      this.networkHandler.packetQueue.enqueue(
        new NetworkQueueEntry(inFlightPacket, [client], inFlightPacket.priority)
      );
      console.log(
        `Resending packet with message type ${inFlightPacket.header.messageType}`
      );
      isPacketResend = true;
    }
    return isPacketResend;
  }
}
