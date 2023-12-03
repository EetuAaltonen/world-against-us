import { v4 as uuidv4 } from "uuid";
import Client from "./Client.js";

const UNDEFINED_UUID = "nuuuuuuu-uuuu-uuuu-uuuu-ullundefined";

export default class ClientHandler {
  constructor() {
    this.clients = [];
  }

  connectClient(rinfo) {
    let newUuid = uuidv4();
    if (newUuid !== undefined) {
      const client = new Client(newUuid, rinfo.address, rinfo.port);
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

  disconnectClient(clientId, clientAddress, clientPort) {
    let isDisconnected = false;
    const index = this.clients.findIndex(
      (client) =>
        (client.uuid === clientId || clientId === UNDEFINED_UUID) &&
        client.address === clientAddress &&
        client.port === clientPort
    );
    if (index > -1) {
      this.clients.splice(index, 1);
      isDisconnected = true;
    }
    return isDisconnected;
  }
}
