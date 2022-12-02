const Dgram = require("dgram");
const { Buffer } = require("node:buffer");

const MESSAGE_TYPE = require("./components/network/messageType");

const PlayerData = require("./components/players/playerData");
const InputMap = require("./components/players/inputMap");
const Vector2 = require("./components/math/vector2");
const InventorySize = require("./components/inventory/inventorySize");

const NetworkService = require("./components/network/networkService");
const FilesService = require("./components/files/fileService");
const PlayersService = require("./components/players/playersService");
const ContainersService = require("./components/containers/containersService");

const ItemsDatabase = require("./components/items/itemsDatabase");
const GridIndex = require("./components/inventory/gridIndex");

const server = Dgram.createSocket("udp4");
const networkService = new NetworkService(server);
const playersService = new PlayersService();

const UNDEFINED_UUID = "nuuuuuuu-uuuu-uuuu-uuuu-ullundefined";
const NULL_TERMINATION = "\0";

const BIT8 = 1;
const BIT16 = 2;
const BIT32 = 4;
const BIT64 = 8;

const data = FilesService.ReadJSON(
  "../zombie-survival-multiplayer/datafiles/item_data1.json"
);
const itemsDatabase = new ItemsDatabase(data.item_data);
const containersService = new ContainersService(itemsDatabase);

server.on("error", (err) => {
  console.log(`server error:\n${err.stack}`);
  server.close();
});

server.on("message", (msg, rinfo) => {
  try {
    // Read first 45 of msg: (8) messageType, (37) clientId
    const messageType = msg.readUInt8(0);
    const idLength = 36;
    const clientId = msg.toString("utf8", BIT8, idLength + BIT8); // messageType is 1 byte
    const skipBytes = Buffer.byteLength(clientId, "utf8") + BIT8; // messageType is 1 byte
    // Slice buffer
    msg = msg.slice(skipBytes);

    switch (messageType) {
      //#region Client
      case MESSAGE_TYPE.LATENCY:
        {
          var tickTime = msg.readBigUInt64LE(0);
          msg.slice(BIT64);

          // Response with the received tick time to latency request
          const bufferUuid = Buffer.from(clientId + NULL_TERMINATION, "utf8");
          const bufferMessageType = Buffer.allocUnsafe(BIT8);
          bufferMessageType.writeUInt8(MESSAGE_TYPE.LATENCY, 0);
          const bufferTickTime = Buffer.allocUnsafe(BIT64);
          bufferTickTime.writeBigUInt64LE(tickTime, 0);

          const buffer = Buffer.concat([
            bufferUuid,
            bufferMessageType,
            bufferTickTime,
          ]);
          server.send(buffer, rinfo.port, rinfo.address);
        }
        break;
      case MESSAGE_TYPE.CONNECT_TO_HOST:
        {
          if (clientId == UNDEFINED_UUID) {
            // Generate new Uuid and save client
            const newUuid = networkService.ConnectClient(rinfo);

            // Response with a new Uuid and all player data
            const bufferUuid = Buffer.from(newUuid + NULL_TERMINATION, "utf8");
            const bufferMessageType = Buffer.allocUnsafe(BIT8);
            bufferMessageType.writeUInt8(MESSAGE_TYPE.CONNECT_TO_HOST, 0);

            const buffer = Buffer.concat([bufferUuid, bufferMessageType]);
            server.send(buffer, rinfo.port, rinfo.address);
          }
        }
        break;
      case MESSAGE_TYPE.DATA_PLAYER_SYNC:
        {
          // Create new player data
          const jsonString = msg.toString("utf8", 0, msg.length);
          const content = JSON.parse(jsonString);
          const newPlayerData = new PlayerData(
            clientId,
            0,
            new Vector2(0, 0),
            new Vector2(0, 0),
            new InputMap()
          );

          const newPosition = new Vector2(
            content.player_data.position.X,
            content.player_data.position.Y
          );

          const newVectorSpeed = new Vector2(
            content.player_data.vector_speed.X,
            content.player_data.vector_speed.Y
          );

          const newInputMap = new InputMap(
            content.player_data.input_map.key_up,
            content.player_data.input_map.key_down,
            content.player_data.input_map.key_let,
            content.player_data.input_map.key_right
          );

          newPlayerData.position = newPosition;
          newPlayerData.vector_speed = newVectorSpeed;
          newPlayerData.input_map = newInputMap;
          newPlayerData.primary_weapon = content.player_data.primary_weapon;

          playersService.AddPlayer(clientId, newPlayerData);

          // Response with all player data
          const bufferUuid = Buffer.from(clientId + NULL_TERMINATION, "utf8");
          const bufferMessageType = Buffer.allocUnsafe(BIT8);
          bufferMessageType.writeUInt8(MESSAGE_TYPE.CONNECT_TO_HOST, 0);
          const bufferAllPlayerData = Buffer.from(
            JSON.stringify(playersService.GetAllPlayers()),
            "utf8"
          );

          const buffer = Buffer.concat([
            bufferUuid,
            bufferMessageType,
            bufferAllPlayerData,
          ]);
          server.send(buffer, rinfo.port, rinfo.address);

          // Broadcast others about a new player data
          const broadcastMessageType = Buffer.allocUnsafe(BIT8);
          broadcastMessageType.writeUInt8(
            MESSAGE_TYPE.OTHER_CONNECTED_TO_HOST,
            0
          );
          const broadcastPlayerData = Buffer.from(
            JSON.stringify(newPlayerData),
            "utf8"
          );

          const broadcastBuffer = Buffer.concat([
            bufferUuid,
            broadcastMessageType,
            broadcastPlayerData,
          ]);
          networkService.BroadcastToClients(broadcastBuffer, clientId);
        }
        break;
      case MESSAGE_TYPE.DISCONNECT_FROM_HOST:
        {
          // Delete disconnected player
          networkService.DisconnectClient(clientId);
          playersService.DeletePlayerById(clientId);

          // Broadcast others about the player disconnect
          const bufferUuid = Buffer.from(clientId + NULL_TERMINATION, "utf8");
          const bufferMessageType = Buffer.allocUnsafe(BIT8);
          bufferMessageType.writeUInt8(
            MESSAGE_TYPE.OTHER_DISCONNECT_FROM_HOST,
            0
          );

          const buffer = Buffer.concat([bufferUuid, bufferMessageType]);
          networkService.BroadcastToClients(buffer, clientId);
        }
        break;
      //#endregion

      //#region Player
      case MESSAGE_TYPE.DATA_PLAYER_POSITION:
        {
          // Read position
          const xPos = msg.readUInt32LE(0);
          msg = msg.slice(BIT32);
          const yPos = msg.readUInt32LE(0);
          msg = msg.slice(BIT32);

          const newPosition = new Vector2(xPos, yPos);
          const playerData = playersService.GetPlayerById(clientId);
          playerData.position = newPosition;

          // Broadcast others about the player position
          const broadcastUuid = Buffer.from(
            clientId + NULL_TERMINATION,
            "utf8"
          );
          const broadcastMessageType = Buffer.allocUnsafe(BIT8);
          broadcastMessageType.writeUInt8(MESSAGE_TYPE.DATA_PLAYER_POSITION, 0);

          const broadcastPlayerX = Buffer.allocUnsafe(BIT32);
          broadcastPlayerX.writeUInt32LE(xPos, 0);
          const broadcastPlayerY = Buffer.allocUnsafe(BIT32);
          broadcastPlayerY.writeUInt32LE(yPos, 0);

          const broadcastBuffer = Buffer.concat([
            broadcastUuid,
            broadcastMessageType,
            broadcastPlayerX,
            broadcastPlayerY,
          ]);
          networkService.BroadcastToClients(broadcastBuffer, clientId);
        }
        break;
      case MESSAGE_TYPE.DATA_PLAYER_VELOCITY:
        {
          // Read position
          const hSpeed = msg.readInt16LE(0);
          msg = msg.slice(BIT16);
          const vSpeed = msg.readInt16LE(0);
          msg = msg.slice(BIT16);

          const newVectorSpeed = new Vector2(hSpeed, vSpeed);
          const playerData = playersService.GetPlayerById(clientId);
          playerData.vector_speed = newVectorSpeed;

          // Broadcast others about the player position
          const broadcastUuid = Buffer.from(
            clientId + NULL_TERMINATION,
            "utf8"
          );
          const broadcastMessageType = Buffer.allocUnsafe(BIT8);
          broadcastMessageType.writeUInt8(MESSAGE_TYPE.DATA_PLAYER_VELOCITY, 0);

          const broadcastPlayerHSpeed = Buffer.allocUnsafe(BIT16);
          broadcastPlayerHSpeed.writeInt16LE(hSpeed, 0);
          const broadcastPlayerVSpeed = Buffer.allocUnsafe(BIT16);
          broadcastPlayerVSpeed.writeInt16LE(vSpeed, 0);

          const broadcastBuffer = Buffer.concat([
            broadcastUuid,
            broadcastMessageType,
            broadcastPlayerHSpeed,
            broadcastPlayerVSpeed,
          ]);
          networkService.BroadcastToClients(broadcastBuffer, clientId);
        }
        break;
      case MESSAGE_TYPE.DATA_PLAYER_MOVEMENT_INPUT:
        {
          // Read inputs
          const keyUp = msg.readUInt8(0);
          msg = msg.slice(BIT8);
          const keyDown = msg.readUInt8(0);
          msg = msg.slice(BIT8);
          const keyLeft = msg.readUInt8(0);
          msg = msg.slice(BIT8);
          const keyRight = msg.readUInt8(0);
          msg = msg.slice(BIT8);

          const newInputMap = new InputMap(keyUp, keyDown, keyLeft, keyRight);
          const playerData = playersService.GetPlayerById(clientId);
          playerData.input_map = newInputMap;

          // Broadcast others about the player movement
          const broadcastUuid = Buffer.from(
            clientId + NULL_TERMINATION,
            "utf8"
          );
          const broadcastMessageType = Buffer.allocUnsafe(BIT8);
          broadcastMessageType.writeUInt8(
            MESSAGE_TYPE.DATA_PLAYER_MOVEMENT_INPUT,
            0
          );

          // Write signed 8bit input values between 1 and -1
          const broadcastKeyUp = Buffer.allocUnsafe(BIT8);
          broadcastKeyUp.writeInt8(newInputMap.key_up, 0);
          const broadcastKeyDown = Buffer.allocUnsafe(BIT8);
          broadcastKeyDown.writeInt8(newInputMap.key_down, 0);
          const broadcastKeyLeft = Buffer.allocUnsafe(BIT8);
          broadcastKeyLeft.writeInt8(newInputMap.key_left, 0);
          const broadcastKeyRight = Buffer.allocUnsafe(BIT8);
          broadcastKeyRight.writeInt8(newInputMap.key_right, 0);

          const broadcastBuffer = Buffer.concat([
            broadcastUuid,
            broadcastMessageType,
            broadcastKeyUp,
            broadcastKeyDown,
            broadcastKeyLeft,
            broadcastKeyRight,
          ]);
          networkService.BroadcastToClients(broadcastBuffer, clientId);
        }
        break;
      //#endregion

      //#region Weapon
      case MESSAGE_TYPE.DATA_PLAYER_WEAPON_FUNCTION:
        {
          // Read functions
          const isWeaponUsed = msg.readUInt8(0);
          msg = msg.slice(BIT8);
          const bulletCount = msg.readUInt8(0); // Value is an 8bit new ammo count
          msg = msg.slice(BIT8);
          const isWeaponAiming = msg.readUInt8(0);
          msg = msg.slice(BIT8);
          const mouseX = msg.readUInt32LE(0);
          msg = msg.slice(BIT32);
          const mouseY = msg.readUInt32LE(0);
          msg = msg.slice(BIT32);

          // Broadcast others about the player movement
          const broadcastUuid = Buffer.from(
            clientId + NULL_TERMINATION,
            "utf8"
          );
          const broadcastMessageType = Buffer.allocUnsafe(BIT8);
          broadcastMessageType.writeUInt8(
            MESSAGE_TYPE.DATA_PLAYER_WEAPON_FUNCTION,
            0
          );

          const broadcastWeaponUsed = Buffer.allocUnsafe(BIT8);
          broadcastWeaponUsed.writeUInt8(isWeaponUsed, 0);
          const broadcastBulletCount = Buffer.allocUnsafe(BIT8);
          broadcastBulletCount.writeUInt8(bulletCount, 0);
          const broadcastWeaponAiming = Buffer.allocUnsafe(BIT8);
          broadcastWeaponAiming.writeUInt8(isWeaponAiming, 0);
          const broadcastMouseX = Buffer.allocUnsafe(BIT32);
          broadcastMouseX.writeUInt32LE(mouseX, 0);
          const broadcastMouseY = Buffer.allocUnsafe(BIT32);
          broadcastMouseY.writeUInt32LE(mouseY, 0);

          const broadcastBuffer = Buffer.concat([
            broadcastUuid,
            broadcastMessageType,
            broadcastWeaponUsed,
            broadcastBulletCount,
            broadcastWeaponAiming,
            broadcastMouseX,
            broadcastMouseY,
          ]);
          networkService.BroadcastToClients(broadcastBuffer, clientId);
        }
        break;
      case MESSAGE_TYPE.DATA_PLAYER_WEAPON_EQUIP:
        {
          const weaponString = msg.toString("utf8", 0, msg.length);
          const newWeapon = JSON.parse(weaponString);

          // Equip a new weapon
          const playerData = playersService.GetPlayerById(clientId);
          playerData.primary_weapon = newWeapon;

          // Broadcast others about the player's new weapon
          const broadcastUuid = Buffer.from(
            clientId + NULL_TERMINATION,
            "utf8"
          );
          const broadcastMessageType = Buffer.allocUnsafe(BIT8);
          broadcastMessageType.writeUInt8(
            MESSAGE_TYPE.DATA_PLAYER_WEAPON_EQUIP,
            0
          );

          const broadcastWeapon = Buffer.from(weaponString);

          const broadcastBuffer = Buffer.concat([
            broadcastUuid,
            broadcastMessageType,
            broadcastWeapon,
          ]);
          networkService.BroadcastToClients(broadcastBuffer, clientId);
        }
        break;
      //#endregion

      //#region Container
      case MESSAGE_TYPE.CONTAINER_REQUEST_CONTENT:
        {
          // Read functions
          const idLength = 13;
          const containerId = msg.toString("utf8", 0, idLength);
          const skipBytes = Buffer.byteLength(containerId, "utf8");
          // Slice buffer
          msg = msg.slice(skipBytes);

          // Fetch items
          const container = containersService.GetContainerById(containerId);
          var containerContent = [];

          console.log(containerId);
          if (container == undefined) {
            const randomItems = itemsDatabase.PickRandom(10);
            containersService.AddContainer(
              containerId,
              "temp",
              new InventorySize(10, 10),
              randomItems,
              false
            );
            containerContent = containersService
              .GetContainerById(containerId)
              .GetAllItems();
          } else {
            containerContent = container.GetAllItems();
          }

          // Response with a container ID and container items
          const bufferUuid = Buffer.from(clientId + NULL_TERMINATION, "utf8");
          const bufferMessageType = Buffer.allocUnsafe(BIT8);
          bufferMessageType.writeUInt8(
            MESSAGE_TYPE.CONTAINER_REQUEST_CONTENT,
            0
          );

          const bufferContainerId = Buffer.from(
            containerId + NULL_TERMINATION,
            "utf8"
          );
          const bufferContainerItems = Buffer.from(
            JSON.stringify(containerContent),
            "utf8"
          );

          const buffer = Buffer.concat([
            bufferUuid,
            bufferMessageType,
            bufferContainerId,
            bufferContainerItems,
          ]);

          server.send(buffer, rinfo.port, rinfo.address);
        }
        break;

      case MESSAGE_TYPE.CONTAINER_ADD_ITEM:
        {
          // Read functions
          const idLength = 13;
          const containerId = msg.toString("utf8", 0, idLength);
          const skipBytes = Buffer.byteLength(containerId, "utf8");
          // Slice buffer
          msg = msg.slice(skipBytes);

          // Add a new item
          const itemString = msg.toString("utf8", 0, msg.length);
          const item = JSON.parse(itemString);

          const container = containersService.GetContainerById(containerId);
          container.AddItem(item, item.grid_index, item.known);
        }
        break;

      case MESSAGE_TYPE.CONTAINER_IDENTIFY_ITEM:
        {
          // Read functions
          const idLength = 13;
          const containerId = msg.toString("utf8", 0, idLength);
          const skipBytes = Buffer.byteLength(containerId, "utf8");
          // Slice buffer
          msg = msg.slice(skipBytes);

          // Identify the item
          const itemString = msg.toString("utf8", 0, msg.length);
          const item = JSON.parse(itemString);

          const container = containersService.GetContainerById(containerId);
          container.IdentifyItemByIndex(item.grid_index);
        }
        break;

      case MESSAGE_TYPE.CONTAINER_MOVE_AND_ROTATE_ITEM:
        {
          // Read functions
          const idLength = 13;
          const containerId = msg.toString("utf8", 0, idLength);
          const skipBytes = Buffer.byteLength(containerId, "utf8");
          // Slice buffer
          msg = msg.slice(skipBytes);

          // Move and rotate the item
          const newColumn = msg.readUInt16LE(0);
          msg = msg.slice(BIT16);
          const newRow = msg.readUInt16LE(0);
          msg = msg.slice(BIT16);
          const isItemRotated = msg.readUInt8(0);
          msg = msg.slice(BIT8);
          const itemString = msg.toString("utf8", 0, msg.length);
          const item = JSON.parse(itemString);

          const container = containersService.GetContainerById(containerId);
          container.MoveAndRotateItemByIndex(
            item.grid_index,
            new GridIndex(newColumn, newRow),
            isItemRotated
          );
        }
        break;

      /*case MESSAGE_TYPE.CONTAINER_MOVE_ITEM:
        {
          // Read functions
          const idLength = 13;
          const containerId = msg.toString("utf8", 0, idLength);
          const skipBytes = Buffer.byteLength(containerId, "utf8");
          // Slice buffer
          msg = msg.slice(skipBytes);

          // Move the item
          const col = msg.readUInt16LE(0);
          msg = msg.slice(BIT16);
          const row = msg.readUInt16LE(0);
          msg = msg.slice(BIT16);
          const itemString = msg.toString("utf8", 0, msg.length);
          const item = JSON.parse(itemString);

          const container = containersService.GetContainerById(containerId);
          container.MoveItemByIndex(item.grid_index, new GridIndex(col, row));
        }
        break;

      case MESSAGE_TYPE.CONTAINER_ROTATE_ITEM:
        {
          // Read functions
          const idLength = 13;
          const containerId = msg.toString("utf8", 0, idLength);
          const skipBytes = Buffer.byteLength(containerId, "utf8");
          // Slice buffer
          msg = msg.slice(skipBytes);

          // Rotate the item
          const isItemRotated = msg.readUInt8(0);
          msg = msg.slice(BIT8);

          const itemString = msg.toString("utf8", 0, msg.length);
          const item = JSON.parse(itemString);

          const container = containersService.GetContainerById(containerId);
          container.RotateItemByIndex(item.grid_index, isItemRotated);
        }
        break;*/

      case MESSAGE_TYPE.CONTAINER_DELETE_ITEM:
        {
          // Read functions
          const idLength = 13;
          const containerId = msg.toString("utf8", 0, idLength);
          const skipBytes = Buffer.byteLength(containerId, "utf8");
          // Slice buffer
          msg = msg.slice(skipBytes);

          // Delete the item
          const itemString = msg.toString("utf8", 0, msg.length);
          const item = JSON.parse(itemString);

          const container = containersService.GetContainerById(containerId);
          container.DeleteItemByIndex(item.grid_index);
        }
        break;
      //#endregion
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
