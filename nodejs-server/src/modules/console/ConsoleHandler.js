import moment from "moment/moment.js";

export default class ConsoleHandler {
  static Log(consoleLog) {
    const formatTimeStamp = moment().format("YYYY-MM-DD HH:mm:ss");
    const formatConsoleLog = `${formatTimeStamp} >> ${consoleLog}`;
    console.log(formatConsoleLog);
  }
}
