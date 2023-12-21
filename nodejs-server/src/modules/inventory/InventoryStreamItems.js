import FormatArrayToJSONStructArray from "../formatting/FormatArrayToJSONStructArray.js";

export default class InventoryStreamItems {
  constructor(instanceId, inventoryId, items) {
    this.instanceId = instanceId;
    this.inventoryId = inventoryId;
    this.items = items;
  }

  toJSONStruct() {
    const formatItems = FormatArrayToJSONStructArray(this.items);
    return {
      instance_id: this.instanceId,
      inventory_id: this.inventoryId,
      items: formatItems,
    };
  }
}
