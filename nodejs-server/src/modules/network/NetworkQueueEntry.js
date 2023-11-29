export default class NetworkQueueEntry {
  constructor(networkPacket, clients, priority) {
    this.networkPacket = networkPacket;
    this.clients = clients;
    this.priority = priority;
  }
}
