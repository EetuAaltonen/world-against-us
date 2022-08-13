const dgram = require("dgram");
const { v1: uuidv1, v4: uuidv4 } = require("uuid");

const server = dgram.createSocket("udp4");

const MESSAGE_TYPE = {
  CONNECT_TO_HOST: 0,
  CLIENT_SYNC: 1,
  LATENCY: 2,
  DATA: 3,
  DISCONNECT: 4,
};

var data;
var content;
var clients = {};
var allPlayerData = [];

server.on("error", (err) => {
  console.log(`server error:\n${err.stack}`);
  server.close();
});

server.on("message", (msg, rinfo) => {
  try {
    data = JSON.parse(msg);

    switch (data.message_type) {
      case MESSAGE_TYPE.CONNECT_TO_HOST:
        {
          var newUuid = uuidv4();
          clients[newUuid] = { address: rinfo.address, port: rinfo.port };
          console.log(clients);

          var uuidPackage = new PackageContent("client_id", newUuid);
          var jsonData = JSON.stringify({
            message_type: MESSAGE_TYPE.CONNECT_TO_HOST,
            content: [uuidPackage],
          });
          console.log(`New client added: ${newUuid}`);
          server.send(jsonData, rinfo.port, rinfo.address);

          // Create new player data
          allPlayerData.push(new PlayerData(newUuid, new Vector2(0, 0)));

          // Inform all other clients
          jsonData = JSON.stringify({
            message_type: MESSAGE_TYPE.DATA,
            content: [new PackageContent("all_player_data", allPlayerData)],
          });
          BroadcastToClients(jsonData);
        }
        break;
      case MESSAGE_TYPE.DISCONNECT:
        {
          delete clients[data.client_id];
          allPlayerData = allPlayerData.filter(
            (x) => x.uuid !== data.client_id
          );
          console.log(`Client ${data.client_id} deleted`);
          console.log(clients);
        }
        break;
      case MESSAGE_TYPE.DATA:
        {
          data.content.forEach((contentItem) => {
            switch (contentItem.key) {
              case "player_position":
                {
                  const newPosition = new Vector2(
                    contentItem.data.X,
                    contentItem.data.Y
                  );
                  const updatedData = allPlayerData.map((obj) => {
                    if (obj.uuid === data.client_id) {
                      return { ...obj, position: newPosition };
                    }
                    return obj;
                  });
                  allPlayerData = updatedData;
                }
                break;
            }
          });

          // Response with all player data package
          var jsonData = JSON.stringify({
            message_type: MESSAGE_TYPE.DATA,
            content: [new PackageContent("all_player_data", allPlayerData)],
          });
          server.send(jsonData, rinfo.port, rinfo.address);
        }
        break;
    }
  } catch (err) {
    console.log(err);
    server.close();
  }
});

server.on("listening", () => {
  const address = server.address();
  console.log(`Server listening ${address.address}:${address.port}`);
});

server.bind(8080);

class PackageContent {
  constructor(key, value) {
    this.key = key;
    this.value = value;
  }
}

class PlayerData {
  constructor(uuid, position) {
    this.uuid = uuid;
    this.position = position;
  }
}

class Vector2 {
  constructor(x, y) {
    this.x = x;
    this.y = y;
  }
}

function BroadcastToClients(jsonData, ignoredClientId = null) {
  for (var id in clients) {
    if (id != ignoredClientId) {
      var client = clients[id];
      server.send(jsonData, client.port, client.address);
    }
  }
}
