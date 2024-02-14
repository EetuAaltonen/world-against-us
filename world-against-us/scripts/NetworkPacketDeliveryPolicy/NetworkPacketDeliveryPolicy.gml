function NetworkPacketDeliveryPolicy(_minimal_header = false, _compress = true, _patch_sequence_number = true, _patch_ack_range = true, _in_flight_track = true) constructor
{
	minimal_header = _minimal_header;
	compress = _compress;
	patch_sequence_number = _patch_sequence_number;
	patch_ack_range = _patch_ack_range;
	in_flight_track = _in_flight_track;
}