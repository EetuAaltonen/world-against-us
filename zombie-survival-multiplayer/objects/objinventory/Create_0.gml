inventory = new Inventory("PlayerBackpack", INVENTORY_TYPE.PlayerBackpack, { columns: 10, rows: 6 });
magazinePockets = new Inventory("PlayerMagazinePocket", INVENTORY_TYPE.MagazinePockets, { columns: 4, rows: 2 }, ["Magazine", "Bullet"]);
medicinePockets = new Inventory("PlayerMedicinePocket", INVENTORY_TYPE.MedicinePockets, { columns: 4, rows: 2 }, ["Medicine"]);