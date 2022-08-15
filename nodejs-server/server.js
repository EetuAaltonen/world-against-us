const dgram = require("dgram");
const { v1: uuidv1, v4: uuidv4 } = require("uuid");

const server = dgram.createSocket("udp4");

const MESSAGE_TYPE = {
  CONNECT_TO_HOST: 0,
  OTHER_CONNECTED_TO_HOST: 1,
  LATENCY: 2,
  DATA: 3,
  DISCONNECT_FROM_HOST: 4,
  OTHER_DISCONNECT_FROM_HOST: 5,
};

var data;
var content;
var clients = {};
var allPlayerData = {};

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

          // Response with new Uuid
          var allPlayerContent = new PackageContent(
            "all_player_data",
            allPlayerData
          );
          var jsonData = JSON.stringify({
            client_id: newUuid,
            message_type: MESSAGE_TYPE.CONNECT_TO_HOST,
            content: [allPlayerContent],
          });
          server.send(jsonData, rinfo.port, rinfo.address);

          // Create new player data
          var newPlayerData = new PlayerData(
            newUuid,
            0,
            new Vector2(0, 0),
            new Vector2(0, 0),
            new InputMap()
          );

          var keyValuePair = data.content[0];
          if (keyValuePair.key == "player_data") {
            const newPosition = new Vector2(
              keyValuePair.value.position.X,
              keyValuePair.value.position.Y
            );

            const newVectorSpeed = new Vector2(
              keyValuePair.value.vector_speed.X,
              keyValuePair.value.vector_speed.Y
            );

            const newInputMap = new InputMap(
              keyValuePair.value.input_map.key_up,
              keyValuePair.value.input_map.key_down,
              keyValuePair.value.input_map.key_let,
              keyValuePair.value.input_map.key_right
            );

            newPlayerData.position = newPosition;
            newPlayerData.vector_speed = newVectorSpeed;
            newPlayerData.input_map = newInputMap;
          }

          allPlayerData[newUuid] = newPlayerData;
          console.log(`New client added: ${newUuid}`);

          // Broadcast others about a new player data
          var playerDataContent = new PackageContent(
            "player_data",
            newPlayerData
          );
          var jsonData = JSON.stringify({
            client_id: newUuid,
            message_type: MESSAGE_TYPE.OTHER_CONNECTED_TO_HOST,
            content: [playerDataContent],
          });
          BroadcastToClients(jsonData, newUuid);
        }
        break;
      case MESSAGE_TYPE.DISCONNECT_FROM_HOST:
        {
          // Delete disconnected player
          delete clients[data.client_id];
          delete allPlayerData[data.client_id];
          console.log(`Client ${data.client_id} deleted`);
          console.log(clients);

          // Broadcast others about the player disconnect
          var jsonData = JSON.stringify({
            client_id: data.client_id,
            message_type: MESSAGE_TYPE.OTHER_DISCONNECT_FROM_HOST,
            content: [],
          });
          BroadcastToClients(jsonData, data.client_id);
        }
        break;
      case MESSAGE_TYPE.DATA:
        {
          data.content.forEach((keyValuePair) => {
            switch (keyValuePair.key) {
              case "player_position":
                {
                  const newPosition = new Vector2(
                    keyValuePair.value.X,
                    keyValuePair.value.Y
                  );
                  allPlayerData[data.client_id].position = newPosition;

                  // Response with all player data package
                  var jsonData = JSON.stringify({
                    client_id: data.client_id,
                    message_type: MESSAGE_TYPE.DATA,
                    content: [
                      new PackageContent("player_position", newPosition),
                    ],
                  });
                  BroadcastToClients(jsonData, data.client_id);
                }
                break;
              case "player_vector_speed":
                {
                  const newVectorSpeed = new Vector2(
                    keyValuePair.value.X,
                    keyValuePair.value.Y
                  );
                  allPlayerData[data.client_id].vector_speed = newVectorSpeed;

                  // Response with all player data package
                  var jsonData = JSON.stringify({
                    client_id: data.client_id,
                    message_type: MESSAGE_TYPE.DATA,
                    content: [
                      new PackageContent("player_vector_speed", newVectorSpeed),
                    ],
                  });
                  BroadcastToClients(jsonData, data.client_id);
                }
                break;

              case "player_input":
                {
                  var newInputs = keyValuePair.value;
                  newInputs.forEach((input) => {
                    allPlayerData[data.client_id].input_map[input.key] =
                      input.value;
                  });

                  // Response with all player data package
                  var jsonData = JSON.stringify({
                    client_id: data.client_id,
                    message_type: MESSAGE_TYPE.DATA,
                    content: [
                      new PackageContent(
                        "player_input",
                        allPlayerData[data.client_id].input_map
                      ),
                    ],
                  });
                  BroadcastToClients(jsonData, data.client_id);
                }
                break;
            }
          });
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
  constructor(uuid, tick_time, position, vector_speed, input_map) {
    this.uuid = uuid;
    this.tick_time = tick_time;
    this.position = position;
    this.vector_speed = vector_speed;
    this.input_map = input_map;
  }
}

class InputMap {
  constructor(key_up = 0, key_down = 0, key_left = 0, key_right = 0) {
    this.key_up = key_up;
    this.key_down = key_down;
    this.key_left = key_left;
    this.key_right = key_right;
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
