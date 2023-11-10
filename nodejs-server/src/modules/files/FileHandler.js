import fs from "fs";
import moment from "moment/moment.js";

export default class FileHandler {
  constructor(saveFilePath, saveFileName) {
    this.saveFilePath = saveFilePath;
    this.saveFileName = saveFileName;
  }

  saveToFile(saveData) {
    let isSaved = false;
    try {
      if (this.checkRelativePathValidation()) {
        const json = JSON.stringify(saveData);
        const filePath = this.fetchRelativeFilePath();
        fs.writeFile(filePath, json, "utf8", (err) => {
          if (err) throw err;
          const timeStamp = moment().format("YYYY-MM-DD hh:mm:ss");
          console.log(`${timeStamp} >> Autosave completed`);
        });
        isSaved = true;
      }
    } catch (error) {
      console.log(error);
    }
    return isSaved;
  }

  loadFromFile() {
    let saveData;
    try {
      const filePath = this.fetchRelativeFilePath();
      if (fs.existsSync(filePath)) {
        const fileData = fs.readFileSync(filePath, { encoding: "utf8" });
        if (fileData !== undefined) {
          saveData = JSON.parse(fileData);
        }
      }
    } catch (error) {
      console.log(error);
    }
    return saveData;
  }

  checkRelativePathValidation() {
    let isPatchValidated = true;
    try {
      if (!fs.existsSync(this.saveFilePath)) {
        fs.mkdirSync(this.saveFilePath, { recursive: true });
      }
    } catch (error) {
      console.log(error);
      isPatchValidated = false;
    }
    return isPatchValidated;
  }

  fetchRelativeFilePath() {
    return `${this.saveFilePath}${this.saveFileName}`;
  }
}
