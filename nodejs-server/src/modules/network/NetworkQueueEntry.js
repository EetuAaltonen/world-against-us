export default class NetworkQueueEntry {
  constructor(packet, clients, priority) {
    this.packet = packet;
    this.clients = clients;
    this.priority = priority;
  }
}
