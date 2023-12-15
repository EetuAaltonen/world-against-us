export default class NetworkPacketDeliveryPolicy {
  constructor() {
    this.patchSequenceNumber = true;
    this.patchAckRange = true;
    this.toInFlightTrack = true;
  }
}
