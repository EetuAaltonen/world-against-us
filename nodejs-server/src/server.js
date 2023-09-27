import Dgram from "dgram";
import "dotenv/config";

import NetworkHandler from "./modules/network/NetworkHandler.js";

const networkHandler = new NetworkHandler();

const server = Dgram.createSocket("udp4");

server.on("error", (err) => {
  console.log(`server error:\n${err.stack}`);
  server.close();
});

server.on("message", (msg, rinfo) => {
  networkHandler.handlePacket(msg, rinfo, server);
});

server.on("listening", () => {
  const address = server.address();
  console.log(`Server listening ${address.address}:${address.port}`);
});

server.bind(process.env.PORT || 8080, process.env.ADDRESS || "127.0.0.1");
