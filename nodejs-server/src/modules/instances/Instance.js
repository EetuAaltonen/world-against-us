export default class Instance {
  constructor(roomIndex) {
    this.roomIndex = roomIndex;
    this.ownerClient = undefined;
    this.localPlayers = {};
  }

  addPlayer(clientId, player) {
    let isPlayerAdded = false;
    if (this.getPlayer(clientId) === undefined) {
      this.localPlayers[clientId] = player;
      if (this.ownerClient === undefined) {
        this.setOwner(clientId);
      }
      isPlayerAdded = true;
    }
    return isPlayerAdded;
  }

  getPlayer(clientId) {
    return this.localPlayers[clientId];
  }

  getPlayerIdFirst() {
    let foundPlayerId = undefined;
    if (this.getPlayerCount > 0) {
      foundPlayerId = Object.keys(this.localPlayers)[0];
    }
    return foundPlayerId;
  }

  getAllPlayerIds(ignoreClientIds = []) {
    return Object.keys(this.localPlayers).filter(
      (clientId) => !ignoreClientIds.includes(clientId)
    );
  }

  getPlayerCount() {
    return Object.keys(this.localPlayers).length;
  }

  setOwner(clientId) {
    this.ownerClient = clientId;
  }

  resetOwner() {
    let isOwnerReset = false;
    if (this.getPlayerCount() > 0) {
      const playerId = this.getPlayerIdFirst();
      if (playerId !== undefined) {
        this.setOwner(playerId);
        isOwnerReset = true;
      } else {
        this.setOwner(undefined);
        isOwnerReset = true;
      }
    } else {
      this.setOwner(undefined);
      isOwnerReset = true;
    }
    return isOwnerReset;
  }

  removePlayer(clientId) {
    let isPlayerRemoved = false;
    if (this.getPlayer(clientId) !== undefined) {
      delete this.localPlayers[clientId];
      isPlayerRemoved = true;
    }
    return isPlayerRemoved;
  }
}
