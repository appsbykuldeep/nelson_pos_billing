import 'package:pos_billing/core/extensions/parse_value_by_map.dart';
import 'package:pos_billing/core/extensions/string_ext.dart';

class ApiConfig {
  final String key;
  final String title;
  final Uri defaultPHPHost;
  final Uri defaultNodeHost;
  final Uri? customPHPHost;
  final Uri? customNodeHost;
  final DateTime? expiryDate;
  final Uri webAppUrl;
  final List<int> validForStandIds;
  final Uri? valetRequestPortal;
  final Uri? receiptViewPortal;
  ApiConfig({
    required this.key,
    required this.title,
    required this.defaultPHPHost,
    required this.defaultNodeHost,
    this.validForStandIds = const [],
    this.customPHPHost,
    this.customNodeHost,
    required this.webAppUrl,
    this.expiryDate,
    this.valetRequestPortal,
    this.receiptViewPortal,
  });

  String get phpBaseApiPath => (customPHPHost ?? defaultPHPHost).toString();
  String get nodeAPIPath => _getNodeAPIPath();
  String get nodeSocketPath => _getNodeSocketPath();

  bool get isExpired =>
      expiryDate != null &&
      expiryDate!.millisecondsSinceEpoch <
          DateTime.now().millisecondsSinceEpoch;

  bool isValidStand(int id) {
    if (validForStandIds.isEmpty) {
      return true;
    }
    return validForStandIds.contains(id);
  }

  String _getNodeAPIPath() {
    final uri = (customNodeHost ?? defaultNodeHost);
    if ([80, 443].contains(uri.port)) {
      return '${uri.scheme}://${uri.host}';
    }
    return '${uri.scheme}://${uri.host}:${uri.port}';
    // return 'http://${uri.host}:${uri.port}';
  }

  String _getNodeSocketPath() {
    final uri = (customNodeHost ?? defaultNodeHost);
    if ([80, 443].contains(uri.port)) {
      return '${uri.scheme}://${uri.host}';
    }
    return '${uri.scheme}://${uri.host}:${uri.port}';
  }

  // factory ApiConfig.forParkingTicketLive() => ApiConfig(
  //   key: "ptlive",
  //   title: "Parking Ticket Live",
  //   defaultPHPHost: Uri.parse("https://ganpatitechnologies.com/vParking"),
  //   defaultNodeHost: Uri.parse("https://82.112.238.169:1101"),
  //   webAppUrl: Uri.parse("https://app.parkingticket.in"),
  //   valetRequestPortal: Uri.parse("https://valet.parkingticket.in"),
  //   receiptViewPortal: Uri.parse("https://parkingticket.in/viewbill"),
  // );

  factory ApiConfig.forCounterTokenLive() => ApiConfig(
    key: "ptlive_v2",
    title: "Parking Ticket Live V2",
    defaultPHPHost: Uri.parse("http://82.112.238.169:1400"),
    defaultNodeHost: Uri.parse("http://82.112.238.169:1400"),
    webAppUrl: Uri.parse("https://app.parkingticket.in"),
    valetRequestPortal: Uri.parse("https://valet.parkingticket.in"),
    receiptViewPortal: Uri.parse("https://parkingticket.in/viewbill"),
  );

  factory ApiConfig.forCounterTokenLocal() => ApiConfig(
    key: "ptlocal",
    title: "Parking Ticket Local",
    defaultPHPHost: Uri.parse("http://82.112.238.169:1400"),
    webAppUrl: Uri.parse("https://app.parkingticket.in"),

    /// For win
    // defaultNodeHost: Uri.parse("http://192.168.29.54:1100"),
    /// For mac
    // defaultNodeHost: Uri.parse("http://192.168.29.114:1100"),
    defaultNodeHost: Uri.parse("http://192.168.29.68:1400"),

    // defaultNodeHost: Uri.parse("http://192.168.29.68:1100"),
    valetRequestPortal: Uri.parse("https://valet.parkingticket.in"),
    receiptViewPortal: Uri.parse("https://parkingticket.in/viewbill"),
  );

  ApiConfig copyWith({
    Uri? customPHPHost,
    Uri? customNodeHost,

    DateTime? expiryDate,
  }) {
    return ApiConfig(
      key: key,
      title: title,
      defaultPHPHost: defaultPHPHost,
      defaultNodeHost: defaultNodeHost,
      webAppUrl: webAppUrl,
      customPHPHost: customPHPHost ?? this.customPHPHost,
      customNodeHost: customNodeHost ?? this.customNodeHost,
      expiryDate: expiryDate ?? this.expiryDate,
      valetRequestPortal: valetRequestPortal,
      receiptViewPortal: receiptViewPortal,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'key': key,
      'title': title,
      'defaultPHPHost': defaultPHPHost.toString(),
      'defaultNodeHost': defaultNodeHost.toString(),
      'webAppUrl': webAppUrl.toString(),
      'customPHPHost': customPHPHost?.toString(),
      'customNodeHost': customNodeHost?.toString(),
      'expiryDate': expiryDate?.toString(),
      'receiptViewPortal': receiptViewPortal?.toString(),
      'valetRequestPortal': valetRequestPortal?.toString(),
      'validForStandIds': validForStandIds.join(","),
    };
  }

  static List<int> _parseStandIds(dynamic data) {
    List<dynamic> standIds = [];
    if (data is String) {
      standIds = data.split(",");
    }
    if (data is List) {
      standIds = [...data];
    }
    return standIds
        .map((e) => e is int ? e : int.tryParse(e.toString()))
        .whereType<int>()
        .toList();
  }

  factory ApiConfig.fromMap(Map<String, dynamic> map) {
    return ApiConfig(
      key: map.getString('key'),
      title: map.getString('title'),
      defaultPHPHost: Uri.parse(map['defaultPHPHost']),
      defaultNodeHost: Uri.parse(map['defaultNodeHost']),
      webAppUrl: Uri.parse(map['webAppUrl']),
      customPHPHost: map.getString('customPHPHost').parseValidUri(),
      customNodeHost: map.getString('customNodeHost').parseValidUri(),
      receiptViewPortal: map.getString('receiptViewPortal').parseValidUri(),
      valetRequestPortal: map.getString('valetRequestPortal').parseValidUri(),
      expiryDate: map.getDateTimeOrNull("expiryDate"),
      validForStandIds: _parseStandIds(map.getValue("validForStandIds")),
    );
  }

  @override
  String toString() {
    return 'ApiConfig(title: $title, defaultPHPHost: $defaultPHPHost, defaultNodeHost: $defaultNodeHost, customPHPHost: $customPHPHost, customNodeHost: $customNodeHost, phpBaseApiPath: $phpBaseApiPath,nodeAPIPath : $nodeAPIPath, nodeSocketPath : $nodeSocketPath,validForStandIds : $validForStandIds)';
  }
}
