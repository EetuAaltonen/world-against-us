// INHERITED EVENT
event_inherited();

inventory = new Inventory(undefined, INVENTORY_TYPE.Facility, { columns: 2, rows: 3 }, ["Fuel"]);
facility = new FacilityGenerator(undefined, inventory, 15);