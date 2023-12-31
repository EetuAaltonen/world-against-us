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
        if (clientConnectionSample.pingSample.isTimedOut()) {
          console.log("Client pinging timed out");
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

  initPinging(clientId, pingSampleRequest) {
    let isInitialized = false;
    if (pingSampleRequest !== undefined) {
      let clientConnectionSample = this.getClientConnectionSample(clientId);
      if (clientConnectionSample !== undefined) {
        const pingSample = clientConnectionSample.pingSample;
        if (pingSample.serverTime > 0) {
          ConsoleHandler.Log("Client pinging started without prior response");
        }
        pingSample.clientTime = pingSampleRequest.clientTime;
        isInitialized = true;
      } else {
        ConsoleHandler.Log("Client pinging without connection sampling");
      }
    }
    return isInitialized;
  }

  startPinging(clientId) {
    let isPinging = false;
    const clientConnectionSample = this.getClientConnectionSample(clientId);
    if (clientConnectionSample !== undefined) {
      const pingSample = clientConnectionSample.pingSample;
      pingSample.serverTime = Math.floor(this.networkHandler.uptime);
      isPinging = true;
    }
    return isPinging;
  }

  stopPinging(clientId, pingSampleResponse) {
    if (pingSampleResponse !== undefined) {
      let clientConnectionSample = this.getClientConnectionSample(clientId);
      if (clientConnectionSample !== undefined) {
        const pingSample = clientConnectionSample.pingSample;
        if (pingSampleResponse.serverTime === pingSample.serverTime) {
          const now = this.networkHandler.uptime;
          clientConnectionSample.ping = now - pingSample.serverTime;
        } else {
          ConsoleHandler.Log(
            `${pingSampleResponse.serverTime} === ${pingSample.serverTime}`
          );
          ConsoleHandler.Log(
            "Client pinging stopped with inconsistent server time"
          );
        }
        pingSample.reset();
      } else {
        ConsoleHandler.Log(
          "Client pinging stopped without initialized connection sampling"
        );
      }
    }
  }

  getClientConnectionSample(clientId) {
    return this.clientConnectionSamples[clientId];
  }

  getAllClientConnectionSampleIds() {
    return Object.keys(this.clientConnectionSamples);
  }

  removeClientConnectionSample(clientId) {
    delete this.clientConnectionSamples[clientId];
  }
}
