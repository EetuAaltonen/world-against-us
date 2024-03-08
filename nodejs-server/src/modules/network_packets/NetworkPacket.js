import MESSAGE_TYPE from "../network/MessageType.js";
import DELIVERY_POLICIES from "./NetworkPacketDeliveryPolicies.js";
import NetworkPacketHeader from "./NetworkPacketHeader.js";

export default class NetworkPacket {
  constructor(header, payload, priority) {
    this.header = header;
    this.payload = payload;
    this.priority = priority;
    this.maxAcknowledgmentAttempt = 2;
    this.acknowledgmentAttempt = 1;
    this.acknowledgmentTimeout = 3000; // == 3s
    this.timeoutTimer = this.acknowledgmentTimeout;

    this.deliveryPolicy =
      DELIVERY_POLICIES[this.header.messageType] ??
      DELIVERY_POLICIES[MESSAGE_TYPE.LENGTH];
  }

  clone() {
    const networkPacketHeaderClone = new NetworkPacketHeader(
      this.header.messageType,
      this.header.clientId
    );
    const networkPacketClone = new NetworkPacket(
      networkPacketHeaderClone,
      this.payload,
      this.priority
    );
    networkPacketClone.deliveryPolicy = this.deliveryPolicy;
    return networkPacketClone;
  }

  update(passedTickTime) {
    if (!isTimedOut()) {
      this.timeoutTimer -= passedTickTime;
    }
  }

  // TODO: Add with acknowledgment attempts
  restartTimeOutTimer() {
    this.timeoutTimer = this.acknowledgmentTimeout;
  }

  isTimedOut() {
    return this.timeoutTimer <= 0;
  }
}
