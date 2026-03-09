import 'package:pos_billing/core/extensions/parse_value_by_map.dart';

class SocketResponse {
  SocketResponse({
    this.event = '',
    this.soketStatus = SoketStatus.done,
    this.soketData,
    this.resultData,
    this.resultStatus = false,
    this.resultMessage = '',
    this.ping,
  });

  String event;
  SoketStatus soketStatus;

  /// Get data as soket sent.
  dynamic soketData;
  // parsed data
  bool resultStatus;
  String resultMessage;
  dynamic resultData;
  int? ping;

  static SocketResponse fetchWithEvent(
    String event,
    dynamic data, {
    SoketStatus soketStatus = SoketStatus.done,
    int? socketPing,
  }) {
    return SocketResponse.fetch(data)
      ..soketStatus = soketStatus
      ..event = event
      ..soketData = data
      ..ping = socketPing;
  }

  static SocketResponse fetch(dynamic data) {
    if (data == null) return SocketResponse();
    try {
      return SocketResponse.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      return SocketResponse();
    }
  }

  factory SocketResponse.fromJson(Map<String, dynamic> json) {
    return SocketResponse(
      resultStatus:
          json.getboolOrNull("resultStatus") ?? json.getbool("ResultStatus"),
      resultMessage:
          json.getStringOrNull("resultMessage") ?? json.getString("ResultMsj"),
      resultData:
          json.getValueOrNull("resultData") ??
          json.getValueOrNull("ResultData"),
    );
  }

  Map<String, dynamic> toJson() => {
    "resultStatus": resultStatus,
    "resultMessage": resultMessage,
    "resultData": resultData,
  };

  @override
  String toString() {
    return "SocketResponse(event:$event,soketData:$soketData,resultStatus:$resultStatus, resultMessage:$resultMessage, resultData:$resultData,resultDataType:${resultData.runtimeType})";
  }
}

class SocketResponseV2 {
  SocketResponseV2({
    this.event = '',
    this.soketStatus = SoketStatus.done,
    this.soketData,
  });

  String event;
  SoketStatus soketStatus;

  /// Get data as soket sent.
  dynamic soketData;

  static SocketResponse fetchWithEvent(
    String event,
    dynamic data, {
    SoketStatus soketStatus = SoketStatus.done,
  }) {
    return SocketResponse.fetch(data)
      ..soketStatus = soketStatus
      ..event = event
      ..soketData = data;
  }
}

enum SoketStatus {
  done,
  notConnected,
  timeout,
  error;

  const SoketStatus();

  bool get isdone => this == done;
  bool get istimeout => this == timeout;
  bool get isnotConnected => this == notConnected;
  bool get iserror => this == error;
}
