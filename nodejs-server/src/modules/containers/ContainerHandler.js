import MESSAGE_TYPE from "../network/MessageType.js";
import PACKET_PRIORITY from "../network/PacketPriority.js";

import Container from "./Container.js";
import NetworkPacket from "../network_packets/NetworkPacket.js";
import NetworkPacketHeader from "../network_packets/NetworkPacketHeader.js";
import InventoryStreamItems from "../inventory/InventoryStreamItems.js";
import NetworkQueueEntry from "../network/NetworkQueueEntry.js";

export default class ContainerHandler {
  constructor(networkHandler) {
    this.networkHandler = networkHandler;
    this.activeInventoryStreams = {};
    this.containers = {};
  }

  addContainer(containerId) {
    let isContainerInitialized = true;
    this.containers[containerId] = new Container(containerId);
    return isContainerInitialized;
  }

  getContainerById(containerId) {
    return this.containers[containerId];
  }

  getAllContainerIds() {
    return Object.keys(this.containers);
  }

  getContainerByRequestingClientId(clientId) {
    let requestedContainer = undefined;
    const containerIds = this.getAllContainerIds();
    const streamCount = containerIds.length;
    for (let i = 0; i < streamCount; i++) {
      const containerId = containerIds[i];
      const container = this.getContainerById(containerId);
      if (container !== undefined) {
        if (container.requestingClient === clientId) {
          requestedContainer = container;
          break;
        }
      }
    }
    return requestedContainer;
  }

  removeContainer(containerId) {
    delete this.containers[containerId];
  }

  addActiveInventoryStream(activeInventoryStream) {
    let isInventoryStreamAdded = false;
    if (activeInventoryStream !== undefined) {
      const targetInventory = activeInventoryStream.targetInventory;
      if (targetInventory !== undefined) {
        const inventoryId = targetInventory.inventoryId;
        if (!Object.keys(this.activeInventoryStreams).includes(inventoryId)) {
          this.activeInventoryStreams[inventoryId] = activeInventoryStream;
          isInventoryStreamAdded = true;
        }
      }
    }
    return isInventoryStreamAdded;
  }

  getActiveInventoryStream(inventoryId) {
    return this.activeInventoryStreams[inventoryId];
  }

  getAllActiveInventoryStreamIds() {
    return Object.keys(this.activeInventoryStreams);
  }

  getActiveInventoryStreamByClientId(clientId) {
    let activeInventoryStream = undefined;
    const inventoryStreamIds = this.getAllActiveInventoryStreamIds();
    const streamCount = inventoryStreamIds.length;
    for (let i = 0; i < streamCount; i++) {
      const streamKey = inventoryStreamIds[i];
      const inventoryStream = this.getActiveInventoryStream(streamKey);
      if (inventoryStream !== undefined) {
        if (inventoryStream.requestingClient === clientId) {
          activeInventoryStream = inventoryStream;
          break;
        }
      }
    }
    return activeInventoryStream;
  }

  removeActiveInventoryStream(inventoryId) {
    delete this.activeInventoryStreams[inventoryId];
  }

  sendNextInventoryStreamItems(activeInventoryStream, instanceId, client) {
    let isItemsSent = true;
    const items = activeInventoryStream.fetchNextInventoryStreamItems();
    const inventoryStreamItems = new InventoryStreamItems(
      instanceId,
      activeInventoryStream.inventoryId,
      items
    );
    if (items.length > 0) {
      const networkPacketHeader = new NetworkPacketHeader(
        MESSAGE_TYPE.CONTAINER_INVENTORY_STREAM,
        client.uuid
      );
      const networkPacket = new NetworkPacket(
        networkPacketHeader,
        inventoryStreamItems.toJSONStruct(),
        PACKET_PRIORITY.DEFAULT
      );
      this.networkHandler.queueNetworkPacket(
        new NetworkQueueEntry(networkPacket, [client])
      );
      isItemsSent = true;
    } else {
      isItemsSent = this.endInventoryStream(
        activeInventoryStream,
        instanceId,
        client
      );
    }
    return isItemsSent;
  }

  requestNextInventoryStreamItems(inventoryId, instanceId, client) {
    let isItemsRequested = true;
    const inventoryStreamItems = new InventoryStreamItems(
      instanceId,
      inventoryId,
      []
    );
    const networkPacketHeader = new NetworkPacketHeader(
      MESSAGE_TYPE.CONTAINER_INVENTORY_STREAM,
      client.uuid
    );
    const networkPacket = new NetworkPacket(
      networkPacketHeader,
      inventoryStreamItems.toJSONStruct(),
      PACKET_PRIORITY.DEFAULT
    );
    this.networkHandler.queueNetworkPacket(
      new NetworkQueueEntry(networkPacket, [client])
    );
    return isItemsRequested;
  }

  endInventoryStream(activeInventoryStream, instanceId, client) {
    this.removeActiveInventoryStream(activeInventoryStream.inventoryId);
    const inventoryStreamItems = new InventoryStreamItems(
      instanceId,
      activeInventoryStream.inventoryId,
      []
    );

    let isInventoryStreamEnded = true;
    const networkPacketHeader = new NetworkPacketHeader(
      MESSAGE_TYPE.END_CONTAINER_INVENTORY_STREAM,
      client.uuid
    );
    const networkPacket = new NetworkPacket(
      networkPacketHeader,
      inventoryStreamItems,
      PACKET_PRIORITY.DEFAULT
    );
    this.networkHandler.queueNetworkPacket(
      new NetworkQueueEntry(networkPacket, [client])
    );
    return isInventoryStreamEnded;
  }
}
