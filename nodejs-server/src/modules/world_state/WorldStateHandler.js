import WEATHER_CONDITION from "./WeatherCondition.js";

import FileHandler from "../files/FileHandler.js";
import WorldStateDateTime from "./WorldStateDateTime.js";
import ParseJSONObjectsToArray from "../json/ParseJSONObjectsToArray.js";
import ParseJSONObjectToItemReplica from "../items/ParseJSONObjectToItemReplica.js";

const SERVER_APPDATA_PATH = `${process.env.LOCALAPPDATA}/world_against_us/server`;
const SERVER_SAVE_FILE_PATH = `${SERVER_APPDATA_PATH}/worlds`;
const GAME_SAVE_NAME = "test";
const GAME_SAVE_FILE_PATH = `${SERVER_SAVE_FILE_PATH}/${GAME_SAVE_NAME}/`;
const GAME_SAVE_FILE_NAME = `${GAME_SAVE_NAME}_save.json`;
const AUTOSAVE_TIME_SECONDS = 600; // Time in seconds == 10min

export default class WorldStateHandler {
  constructor(networkHandler, instanceHandler) {
    this.networkHandler = networkHandler;
    this.instanceHandler = instanceHandler;
    this.dateTime = new WorldStateDateTime(this);
    this.weather = 0;

    this.fileHandler = new FileHandler(
      GAME_SAVE_FILE_PATH,
      GAME_SAVE_FILE_NAME
    );
    this.autoSaveTimer = 0;
  }

  toJSONObject() {
    const formatDateTime = this.dateTime.toJSONObject();
    let formatCampStorage = {};

    const campStorageContainer =
      this.instanceHandler.getDefaultCampStorageContainer();
    if (campStorageContainer !== undefined) {
      formatCampStorage = campStorageContainer.toJSONObject();
    }

    return {
      date_time: formatDateTime,
      camp_storage: formatCampStorage,
    };
  }

  update(passedTickTime) {
    let isUpdated = false;
    // Update date time
    if (this.dateTime.update(passedTickTime)) {
      // Check autosave
      this.autoSaveTimer += passedTickTime * 0.001;
      if (this.autoSaveTimer >= AUTOSAVE_TIME_SECONDS) {
        this.autoSaveTimer -= AUTOSAVE_TIME_SECONDS;
        if (!this.autosave()) {
          isUpdated = false;
        }
      }
    }
    return isUpdated;
  }

  autosave() {
    let isAutoSaveCompleted = false;
    const worldStateJSONObject = this.toJSONObject();
    if (worldStateJSONObject !== undefined) {
      if (this.fileHandler.saveToFile(worldStateJSONObject)) {
        this.autoSaveTimer = 0;
        isAutoSaveCompleted = true;
      }
    }
    return isAutoSaveCompleted;
  }

  loadSave() {
    let isSaveLoaded = false;
    const worldStateJSONObject = this.toJSONObject();
    if (worldStateJSONObject !== undefined) {
      const saveData = this.fileHandler.loadFromFile();
      if (saveData !== undefined) {
        isSaveLoaded = true;
        const jsonDateTimeObject = saveData["date_time"] ?? undefined;
        if (jsonDateTimeObject !== undefined) {
          this.dateTime.year = jsonDateTimeObject["year"] ?? 0;
          this.dateTime.month = jsonDateTimeObject["month"] ?? 0;
          this.dateTime.day =
            jsonDateTimeObject["day"] ?? this.dateTime.defaultDay;
          this.dateTime.hours =
            jsonDateTimeObject["hours"] ?? this.dateTime.defaultHours;
          this.dateTime.minutes = jsonDateTimeObject["minutes"] ?? 0;
          this.dateTime.seconds = jsonDateTimeObject["seconds"] ?? 0;
          this.dateTime.timeScale =
            jsonDateTimeObject["time_scale"] ?? this.dateTime.defaultTimeScale;
        } else {
          isSaveLoaded = false;
        }
        const jsonCampStorageObject = saveData["camp_storage"] ?? undefined;
        if (jsonCampStorageObject !== undefined) {
          const jsonStorageInventory = jsonCampStorageObject["inventory"];
          if (jsonStorageInventory !== undefined) {
            const campStorageContainer =
              this.instanceHandler.getDefaultCampStorageContainer();
            if (campStorageContainer !== undefined) {
              const jsonItemArray = jsonStorageInventory["items"] ?? [];
              const parsedItems = ParseJSONObjectsToArray(
                jsonItemArray,
                ParseJSONObjectToItemReplica
              );
              if (!campStorageContainer.inventory.addItems(parsedItems)) {
                isSaveLoaded = false;
              }
            } else {
              isSaveLoaded = false;
            }
          } else {
            isSaveLoaded = false;
          }
        } else {
          isSaveLoaded = false;
        }
      } else {
        isSaveLoaded = true;
      }
    }
    return isSaveLoaded;
  }

  rollWeather() {
    let isWeatherRolled = false;
    const keys = Object.keys(WEATHER_CONDITION);
    const randomKey = keys[(keys.length * Math.random()) << 0];
    const newWeatherCondition = WEATHER_CONDITION[randomKey];
    if (this.weather != newWeatherCondition) {
      this.weather = newWeatherCondition;
      isWeatherRolled = this.networkHandler.broadcastWeather(this.weather);
    } else {
      isWeatherRolled = true;
    }
    return isWeatherRolled;
  }
}
