import Dgram from "node:dgram";
import "dotenv/config";

import NetworkHandler from "./modules/network/NetworkHandler.js";

const server = Dgram.createSocket("udp4");
const networkHandler = new NetworkHandler(server);

async function init() {
  server.on("error", (error) => {
    console.log(`server error:\n${error.stack}`);
    server.close();
  });

  server.on("message", (msg, rinfo) => {
    try {
      if (!networkHandler.handleMessage(msg, rinfo)) {
        console.log(`Failed to handle a message from a client`);
      }
    } catch (error) {
      networkHandler.onError(error);
      setTimeout(() => {
        console.log(`server error:\n${error.stack}`);
        server.close();
      }, 2000);
    }
  });

  server.on("listening", () => {
    const address = server.address();
    console.log(`Server listening ${address.address}:${address.port}`);
  });

  server.bind(process.env.PORT || 8080, process.env.ADDRESS || "127.0.0.1");

  while (true) {
    await networkHandler.update();
  }
}

init();
