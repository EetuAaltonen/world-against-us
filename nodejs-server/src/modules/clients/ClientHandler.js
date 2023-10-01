import { v4 as uuidv4 } from "uuid";
import Client from "./Client.js";

export default class ClientHandler {
  constructor() {
    this.clients = [];
  }

  connectClient(rinfo) {
    let newUuid = uuidv4();
    const client = new Client(newUuid, rinfo.address, rinfo.port);

    this.clients.push(client);
    return newUuid;
  }

  getClient(clientId) {
    return this.clients.find((client) => client.uuid === clientId);
  }

  getAllClients() {
    return Object.values(this.clients);
  }

  disconnectClient(clientId, rinfo) {
    let isDisconnected = false;
    const index = this.clients.findIndex(
      (client) => client.uuid === clientId && client.address === rinfo.address
    );
    if (index > -1) {
      this.clients.splice(index, 1);
      isDisconnected = true;
    }
    return isDisconnected;
  }
}
