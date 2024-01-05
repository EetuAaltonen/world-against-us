import { v4 as uuidv4 } from "uuid";
import Client from "./Client.js";

const UNDEFINED_UUID = "nuuuuuuu-uuuu-uuuu-uuuu-ullundefined";

export default class ClientHandler {
  constructor() {
    this.clients = [];
  }

  addClient(rinfo, playerTag) {
    let newUuid = uuidv4();
    if (newUuid !== undefined) {
      const client = new Client(newUuid, rinfo.address, rinfo.port, playerTag);
      this.clients.push(client);
    }
    return newUuid;
  }

  getClient(clientId) {
    return this.clients.find((client) => client.uuid === clientId);
  }

  getAllClients() {
    return Object.values(this.clients);
  }

  getClientCount() {
    return Object.keys(this.clients).length;
  }

  removeClient(clientId, clientAddress, clientPort) {
    let isRemoved = false;
    const index = this.clients.findIndex(
      (client) =>
        (client.uuid === clientId || clientId === UNDEFINED_UUID) &&
        client.address === clientAddress &&
        client.port === clientPort
    );
    if (index > -1) {
      this.clients.splice(index, 1);
      isRemoved = true;
    }
    return isRemoved;
  }
}
