const fs = require("fs");

class FileReader {
  static ReadJSON = function (file_path) {
    var obj = JSON.parse(fs.readFileSync(file_path, "utf8"));
    return obj;
  };
}

module.exports = FileReader;
