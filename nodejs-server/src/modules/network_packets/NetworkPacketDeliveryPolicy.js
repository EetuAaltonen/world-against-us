export default class NetworkPacketDeliveryPolicy {
  constructor(
    minimalHeader = false,
    compress = true,
    patchSequenceNumber = true,
    patchAckRange = true,
    toInFlightTrack = true
  ) {
    this.minimalHeader = minimalHeader;
    this.compress = compress;
    this.patchSequenceNumber = patchSequenceNumber;
    this.patchAckRange = patchAckRange;
    this.toInFlightTrack = toInFlightTrack;
  }
}
