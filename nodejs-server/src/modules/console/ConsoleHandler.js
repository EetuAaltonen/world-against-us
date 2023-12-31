export default class ConsoleHandler {
  static Log(consoleLog) {
    const currentDate = new Date();
    const formatDateTime = currentDate.toISOString();
    const formatConsoleLog = `${formatDateTime} ${consoleLog}`;
    console.log(formatConsoleLog);
  }
}
