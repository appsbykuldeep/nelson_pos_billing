enum PrinterStatus {
  connected,
  disconnected,
  connecting;

  bool get isInProgress => this == connected || this == connecting;
  bool get isconnected => this == connected;
  bool get isdisconnected => this == disconnected;
  bool get isconnecting => this == connecting;
}
