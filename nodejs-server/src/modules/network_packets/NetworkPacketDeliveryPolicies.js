import MESSAGE_TYPE from "../network/MessageType.js";
import NetworkPacketDeliveryPolicy from "./NetworkPacketDeliveryPolicy.js";

const networkPacketDeliveryPolicies = {};

networkPacketDeliveryPolicies[MESSAGE_TYPE.ACKNOWLEDGMENT] =
  new NetworkPacketDeliveryPolicy(false, true, true, true, false);
networkPacketDeliveryPolicies[MESSAGE_TYPE.PING] =
  new NetworkPacketDeliveryPolicy(true, false, false, false, false);
// TODO: Use minimal header with MESSAGE_TYPE.DISCONNECT_FROM_HOST
networkPacketDeliveryPolicies[MESSAGE_TYPE.DISCONNECT_FROM_HOST] =
  new NetworkPacketDeliveryPolicy(false, false, false, false, false);
// TODO: Use minimal header with MESSAGE_TYPE.INVALID_REQUEST
networkPacketDeliveryPolicies[MESSAGE_TYPE.INVALID_REQUEST] =
  new NetworkPacketDeliveryPolicy(false, false, false, false, false);
// TODO: Use minimal header with MESSAGE_TYPE.SERVER_ERROR
networkPacketDeliveryPolicies[MESSAGE_TYPE.SERVER_ERROR] =
  new NetworkPacketDeliveryPolicy(false, false, false, false, false);

// Default
networkPacketDeliveryPolicies[MESSAGE_TYPE.LENGTH] =
  new NetworkPacketDeliveryPolicy();

export default networkPacketDeliveryPolicies;
