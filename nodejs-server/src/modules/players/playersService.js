class PlayersService {
  constructor() {
    this.players = {};
  }

  AddPlayer(uuid, player) {
    this.players[uuid] = player;
  }

  GetPlayerById(uuid) {
    return this.players[uuid];
  }

  GetAllPlayers() {
    return this.players;
  }

  DeletePlayerById(uuid) {
    delete this.players[uuid];
  }
}

module.exports = PlayersService;
