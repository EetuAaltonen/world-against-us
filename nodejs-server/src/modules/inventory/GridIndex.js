export default class GridIndex {
  constructor(col, row) {
    this.col = col;
    this.row = row;
  }

  toJSONStruct() {
    return {
      col: this.col,
      row: this.row,
    };
  }
}
