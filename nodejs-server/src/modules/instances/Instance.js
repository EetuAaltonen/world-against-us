export default class Instance {
  constructor(roomIndex) {
    this.roomIndex = roomIndex;
    this.localPlayers = {};
  }

  addPlayer(clientId, player) {
    let isPlayerAdded = false;
    if (this.getPlayer(clientId) === undefined) {
      this.localPlayers[clientId] = player;
      isPlayerAdded = true;
    }
    return isPlayerAdded;
  }

  getPlayer(clientId) {
    return this.localPlayers[clientId];
  }

  getPlayerCount() {
    return Object.keys(this.localPlayers).length;
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
