export default class InvalidRequestInfo {
  constructor(requestAction, originalMessageType, invalidationMessage) {
    this.requestAction = requestAction;
    this.originalMessageType = originalMessageType;
    this.invalidationMessage = invalidationMessage;
  }
}
