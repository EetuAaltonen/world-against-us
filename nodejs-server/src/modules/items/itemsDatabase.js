class ItemsDatabase {
  constructor(item_data) {
    this.items = item_data;
  }

  PickRandom(count) {
    const randomItems = [];
    const totalItemCount = this.items.length;

    for (var i = 0; i < count; i++) {
      const item = this.items[Math.floor(Math.random() * totalItemCount)];
      randomItems.push(item);
    }
    return randomItems;
  }
}

module.exports = ItemsDatabase;
