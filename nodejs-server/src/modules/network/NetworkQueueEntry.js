export default class NetworkQueueEntry {
  constructor(networkPacket, clients) {
    this.networkPacket = networkPacket;
    this.clients = clients;
  }
}
