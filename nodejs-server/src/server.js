import Dgram from "node:dgram";
import "dotenv/config";

import ConsoleHandler from "./modules/console/ConsoleHandler.js";
import NetworkHandler from "./modules/network/NetworkHandler.js";

const server = Dgram.createSocket("udp4");
const networkHandler = new NetworkHandler(server);

function init() {
  server.on("error", (error) => {
    ConsoleHandler.Log(`Server error:\n${error.stack}`);
    networkHandler.onServerClose();
  });

  server.on("message", (msg, rinfo) => {
    try {
      networkHandler.handleMessage(msg, rinfo);
    } catch (error) {
      networkHandler.onError(error);
      setTimeout(() => {
        ConsoleHandler.Log(`Server error:\n${error.stack}`);
        networkHandler.onServerClose();
      }, 2000);
    }
  });

  server.on("listening", () => {
    const address = server.address();
    ConsoleHandler.Log(`Server listening ${address.address}:${address.port}`);
  });

  server.bind(process.env.PORT || 8080, process.env.ADDRESS || "127.0.0.1");

  networkHandler.tick();
}

init();
