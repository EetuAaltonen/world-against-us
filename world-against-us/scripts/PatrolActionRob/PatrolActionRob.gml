function PatrolActionRob(_regionId, _patrolId, _targetNetworkId, _targetPlayetTag) constructor
{
	region_id = _regionId;
	patrol_id = _patrolId;
	target_network_id = _targetNetworkId;
	target_player_tag = _targetPlayetTag;
	
	static ToJSONStruct = function()
	{
		return {
			region_id: region_id,
			patrol_id: patrol_id,
			target_network_id: target_network_id,
			target_player_tag: target_player_tag
		}
	}
}