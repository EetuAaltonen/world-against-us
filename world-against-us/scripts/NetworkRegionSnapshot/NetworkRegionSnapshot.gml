function NetworkRegionSnapshot(_region_id, _local_players, _local_patrols) constructor
{
	region_id = _region_id;
	local_players = _local_players;
	local_player_count = array_length(local_players);
	local_patrols = _local_patrols;
	local_patrol_count = array_length(local_patrols);
}