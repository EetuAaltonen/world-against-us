import ConsoleHandler from "../console/ConsoleHandler.js";
import NetworkConnectionSample from "./NetworkConnectionSample.js";

export default class NetworkConnectionSampler {
  constructor(networkHandler, clientHandler) {
    this.networkHandler = networkHandler;
    this.clientHandler = clientHandler;
    this.clientConnectionSamples = {};
  }

  update(passedTickTime) {
    let isUpdated = true;
    this.getAllClientConnectionSampleIds().forEach((clientId) => {
      const clientConnectionSample = this.getClientConnectionSample(clientId);
      if (clientConnectionSample !== undefined) {
        clientConnectionSample.update(passedTickTime);
        // Check Ping timeout
        if (clientConnectionSample.pingSampler.isTimedOut()) {
          console.log(`${clientId} pinging timed out`);
          const client = this.clientHandler.getClient(clientId);
          if (client !== undefined) {
            this.networkHandler.disconnectClientWithTimeout(
              client.uuid,
              client.address,
              client.port
            );
          }
        }
      }
    });
    return isUpdated;
  }

  addConnectionSample(clientId) {
    let isSamplingAdded = false;
    if (!Object.keys(this.clientConnectionSamples).includes(clientId)) {
      this.clientConnectionSamples[clientId] = new NetworkConnectionSample();
      isSamplingAdded = true;
    }
    return isSamplingAdded;
  }

  updateClientSendRate(clientId, bufferSizeInBytes) {
    const clientConnectionSample = this.getClientConnectionSample(clientId);
    if (clientConnectionSample !== undefined) {
      // Convert to kilobits
      const sentPacketSize = bufferSizeInBytes * 8 * 0.001;
      clientConnectionSample.dataSentRate += sentPacketSize;
    }
  }

  getClientConnectionSample(clientId) {
    return this.clientConnectionSamples[clientId];
  }

  getAllClientConnectionSampleIds() {
    return Object.keys(this.clientConnectionSamples);
  }

  handlePingMessage(clientTime, client) {
    let isMessageHandled = false;
    const clientConnectionSample = this.getClientConnectionSample(client.uuid);
    if (clientConnectionSample !== undefined) {
      // Sample ping
      clientConnectionSample.pingSampler.processPingSample(clientTime);
      isMessageHandled = true;
    } else {
      ConsoleHandler.Log("Client pinging without connection sampling");
    }
    return isMessageHandled;
  }

  removeClientConnectionSample(clientId) {
    delete this.clientConnectionSamples[clientId];
  }
}
