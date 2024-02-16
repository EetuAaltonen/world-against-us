import { v4 as uuidv4 } from "uuid";
import Client from "./Client.js";

const UNDEFINED_UUID = "nuuuuuuu-uuuu-uuuu-uuuu-ullundefined";

export default class ClientHandler {
  constructor() {
    this.clients = {};
  }

  addClient(rinfo, playerTag) {
    let newUuid = uuidv4();
    if (newUuid !== undefined) {
      this.clients[newUuid] = new Client(
        newUuid,
        rinfo.address,
        rinfo.port,
        playerTag
      );
    }
    return newUuid;
  }

  getClient(clientId) {
    return this.clients[clientId];
  }

  getClientBySocket(port, address) {
    const allClients = this.getAllClients();
    return allClients.find(
      (client) => client.port === port && client.address === address
    );
  }

  getAllClients() {
    return Object.values(this.clients);
  }

  getClientsToBroadcastGlobal(excludeClientId = UNDEFINED_UUID) {
    return this.getAllClients().filter((client) => {
      return client.uuid !== excludeClientId;
    });
  }

  getClientsToBroadcastInGame(excludeClientId = UNDEFINED_UUID) {
    return this.getAllClients().filter((client) => {
      return client.instanceId !== undefined && client.uuid !== excludeClientId;
    });
  }

  getClientsToBroadcastInstance(instanceId, excludeClientId = UNDEFINED_UUID) {
    return this.getAllClients().filter((client) => {
      return (
        client.instanceId === instanceId && client.uuid !== excludeClientId
      );
    });
  }

  getClientCount() {
    return Object.keys(this.clients).length;
  }

  removeClient(clientId, clientAddress, clientPort) {
    let isRemoved = false;
    // TODO: removeClient is called multiple times after timed out client
    const clientToDelete = this.getAllClients().find(
      (client) =>
        (client.uuid === clientId || clientId === UNDEFINED_UUID) &&
        client.address === clientAddress &&
        client.port === clientPort
    );
    if (clientToDelete !== undefined) {
      delete this.clients[clientToDelete.uuid];
      isRemoved = true;
    }
    return isRemoved;
  }
}
