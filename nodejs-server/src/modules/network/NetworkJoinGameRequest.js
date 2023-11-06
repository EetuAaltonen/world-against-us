export default class NetworkJoinGameRequest {
  constructor(instanceId, roomIndex, ownerClient) {
    this.instance_id = instanceId;
    this.room_index = roomIndex;
    this.owner_client = ownerClient;
  }
}
