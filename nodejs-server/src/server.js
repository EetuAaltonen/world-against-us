import Dgram from "node:dgram";
import "dotenv/config";

import NetworkHandler from "./modules/network/NetworkHandler.js";

const server = Dgram.createSocket("udp4");
const networkHandler = new NetworkHandler(server);

function init() {
  server.on("error", (error) => {
    console.log(`Server error:\n${error.stack}`);
    networkHandler.onServerClose();
  });

  server.on("message", (msg, rinfo) => {
    try {
      if (!networkHandler.handleMessage(msg, rinfo)) {
        console.log(`Failed to handle a message from a client`);
        networkHandler.onInvalidRequest("Unable to handle the request", rinfo);
      }
    } catch (error) {
      networkHandler.onError(error);
      setTimeout(() => {
        console.log(`Server error:\n${error.stack}`);
        networkHandler.onServerClose();
      }, 2000);
    }
  });

  server.on("listening", () => {
    const address = server.address();
    console.log(`Server listening ${address.address}:${address.port}`);
  });

  server.bind(process.env.PORT || 8080, process.env.ADDRESS || "127.0.0.1");

  networkHandler.tick();
}

init();
