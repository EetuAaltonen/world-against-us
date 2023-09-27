const { v4: uuidv4 } = require("uuid");

class NetworkService {
  constructor(server) {
    this.server = server;
    this.clients = {};
  }

  ConnectClient(rinfo) {
    const newUuid = uuidv4();
    this.clients[newUuid] = { address: rinfo.address, port: rinfo.port };
    console.log(this.clients);
    return newUuid;
  }

  BroadcastToClients(buffer, ignoredClientId = null) {
    for (var id in this.clients) {
      if (id != ignoredClientId) {
        var client = this.clients[id];
        this.server.send(buffer, client.port, client.address);
      }
    }
  }

  DisconnectClient(clientId) {
    delete this.clients[clientId];
    console.log(`Client ${clientId} deleted`);
    console.log(this.clients);
  }
}

module.exports = NetworkService;
