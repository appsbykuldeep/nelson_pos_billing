import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:pos_billing/common/classes/parse_map_value.dart';
import 'package:pos_billing/common/classes/socketio_handler.dart';
import 'package:pos_billing/common/dialogues/show_loading.dart';
import 'package:pos_billing/common/models/basic/apiresponse_model.dart';
import 'package:pos_billing/common/singletons/app.dart';
import 'package:pos_billing/common/singletons/device_package_info.dart';
import 'package:pos_billing/common/singletons/internet_connectivity.dart';
import 'package:pos_billing/common/singletons/login_ctrl.dart';
import 'package:pos_billing/config/constants/connection_apis.dart';
import 'package:pos_billing/config/constants/node_apis.dart';
import 'package:pos_billing/config/constants/soket_events.dart';
import 'package:pos_billing/config/enums/api_progess.dart';
import 'package:pos_billing/core/extensions/string_ext.dart';

final _loginCrl = LoginUtil.instance;

Future<ApiResponse> baseApiCall({
  required String url,
  Map<String, dynamic>? apibody,
  Map<String, String>? apiheders,
  bool? bygetmethod,
  bool showloading = true,
  int timeout = 120,
  int maxretry = 2,
  ValueChanged<ApiProgessStatus?>? progessStatus,
}) async {
  final reRoutepath = ApiList.getReroutPath(url);
  if (kIsWeb &&
      SocketIoHandler.isSocketConnected.value &&
      reRoutepath != null) {
    apiheders = apiheders ?? {};
    apibody = apibody ?? {};

    apiheders["reroutepath"] = reRoutepath;
    apiheders["token"] = 'shopqrapirequest';

    apibody['BuildId'] = NodeApis.buildNumberForWeb;

    final resp0 = await SocketIoHandler.emitWithResponseForCurrentUser(
      SoketEvents.rerouteHandler,
      {"body": apibody, "headers": apiheders, "bygetmthod": bygetmethod},
    );

    return ApiResponse(
      resultStatus: resp0.resultStatus,
      resultMsj: resp0.resultMessage,
      resultData: resp0.resultData,
      apiBody: resp0.soketData,
    );

    // return await _baseApiCallViaHttp(
    //   url: NodeApis.reRoute,
    //   apibody: apibody,
    //   apiheders: apiheders,
    //   bygetmethod: bygetmethod,
    //   showloading: showloading,
    //   timeout: timeout,
    // );
  }

  return await _baseApiCall(
    url: url,
    apibody: apibody,
    apiheders: apiheders,
    bygetmethod: bygetmethod,
    showloading: showloading,
    timeout: timeout,

    progessStatus: progessStatus,
  );
}

Future<ApiResponse> makeApiCall({
  required String url,
  Map<String, dynamic>? apibody,
  Map<String, String>? apiheders,
  bool? bygetmethod,
  bool showloading = true,
  int timeout = 120,
  int maxretry = 2,
  ValueChanged<ApiProgessStatus?>? progessStatus,
}) {
  if (_loginCrl.isLoggedIn) {
    apibody = apibody ?? {};
    apibody = {..._loginCrl.userDetailsMap, ...apibody};

    apiheders ??= {};

    final user = _loginCrl.userNotifier.value;

    apiheders['userId'] = user.userId.toString();
    apiheders['lastLoginKey'] = user.lastLoginKey;
  }

  return baseApiCall(
    url: url,
    apibody: apibody,
    apiheders: apiheders,
    bygetmethod: bygetmethod,
    showloading: showloading,
    timeout: timeout,
    progessStatus: progessStatus,
  );
}

Future<ApiResponse> _baseApiCall({
  required String url,
  Map<String, dynamic>? apibody,
  Map<String, String>? apiheders,
  bool? bygetmethod,
  bool showloading = true,
  int timeout = 50,
  ValueChanged<ApiProgessStatus?>? progessStatus,
  // int maxretry = 2,
}) async {
  ApiResponse responsemodel = ApiResponse();

  if (InternetConnectivity.notAvailable) {
    responsemodel
      ..statusCode = -1
      ..internetAvailable = false
      ..resultMsj = "No internet available !";
    return responsemodel;
  }

  if (showloading) {
    LoadingDialogue.show();
  }

  bool printConsole = kDebugMode;
  progessStatus?.call(ApiProgessStatus.sending);

  try {
    bygetmethod = bygetmethod ?? false;

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'token': 'shopqrapirequest',
    };

    if (apiheders != null) {
      headers.addAll(apiheders);
    }

    apibody = {...apibody ?? {}};
    final dio = Dio();

    final options = Options(
      validateStatus: (status) => true,
      // responseType: ResponseType.plain,
      headers: headers,
      sendTimeout: Duration(seconds: timeout),
      receiveTimeout: Duration(seconds: timeout),
    );

    apibody['BuildId'] =
        DevicePackageDetails.instance.details.value.buildNumber;

    Response response;
    // ignore: dead_code
    if (printConsole) {
      url.developerLog();
      jsonEncode(apibody).developerLog();
      jsonEncode(headers).developerLog();
    }

    progessStatus?.call(ApiProgessStatus.waiting);

    final timeoutDur = Duration(seconds: timeout);

    if (bygetmethod) {
      url = _withQueryParams(url, apibody);
      response = await dio.get(url, options: options).timeout(timeoutDur);
    } else {
      response = await dio
          .post(url, data: apibody, options: options)
          .timeout(timeoutDur);
    }
    progessStatus?.call(ApiProgessStatus.receiving);
    // ignore: dead_code
    if (printConsole) {
      response.statusCode.toString().developerLog();
      // response.data.toString().developerLog();
    }
    responsemodel.apiBody = response.data;
    responsemodel.statusCode = response.statusCode ?? 0;
    if ([200, 201].contains(response.statusCode)) {
      final parser = ParseMapValue(input: response.data);

      responsemodel.statusCode = response.statusCode!;
      responsemodel.resultStatus = parser.fetchbool([
        'resultStatus',
        'resultstatus',
      ]);

      responsemodel.resultMsj = parser.fetchString([
        'resultMessage',
        'resultmessage',
        'ResultMsj',
      ]);

      responsemodel.resultData = parser.fetchdynamic([
        'resultData',
        'resultdata',
      ]);
    } else {
      responsemodel.resultMsj = errorMsjBucode(responsemodel.statusCode);
    }
  } on TimeoutException {
    responsemodel.resultMsj = "Request time out !";
  } on DioException catch (de) {
    responsemodel.resultMsj = switch (de.type) {
      DioExceptionType.connectionError => "Failed to connect.",
      DioExceptionType.connectionTimeout => "Connection timeout.",
      _ => de.message ?? "Something is wong.",
    };
  } catch (e) {
    responsemodel.resultMsj = e.toString();
    progessStatus?.call(ApiProgessStatus.none);
  }

  if (printConsole) {
    (
      responsemodel.statusCode,
      responsemodel.resultMsj,
      responsemodel.apiBody,
    ).toString().developerLog();
    // jsonEncode(apibody).developerLog();
  }

  if (showloading) {
    LoadingDialogue.hide();
  }

  return responsemodel;
}

Future<ApiResponse> _baseApiCallViaHttp({
  required String url,
  Map<String, dynamic>? apibody,
  Map<String, String>? apiheders,
  bool? bygetmethod,
  bool showloading = true,
  int timeout = 50,
  // int maxretry = 2,
}) async {
  ApiResponse responsemodel = ApiResponse();

  if (InternetConnectivity.notAvailable) {
    responsemodel
      ..statusCode = -1
      ..internetAvailable = false
      ..resultMsj = "No internet available !";
    return responsemodel;
  }

  if (showloading) {
    LoadingDialogue.show();
  }

  bool printConsole = kDebugMode;

  try {
    bygetmethod = bygetmethod ?? false;

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'token': 'shopqrapirequest',
      ...apiheders ?? {},
    };

    apibody = {...apibody ?? {}};

    apibody['BuildId'] =
        DevicePackageDetails.instance.details.value.buildNumber;

    apibody['AppType'] = App.company.name;

    http.Response response;
    // ignore: dead_code
    if (printConsole) {
      url.developerLog();
      jsonEncode(apibody).developerLog();
    }

    if (bygetmethod) {
      url = _withQueryParams(url, apibody);
      response = await http
          .get(Uri.parse(url), headers: headers)
          .timeout(Duration(seconds: timeout));
    } else {
      response = await http
          .post(Uri.parse(url), body: jsonEncode(apibody), headers: headers)
          .timeout(Duration(seconds: timeout));
    }
    // ignore: dead_code
    if (printConsole) {
      response.statusCode.toString().developerLog();
      response.body.developerLog();
    }

    dynamic responseData;

    try {
      if (response.body.isNotEmpty) {
        responseData = jsonDecode(response.body);
      } else {
        responseData = response.body;
      }
    } catch (e) {
      responseData = response.body;
    }

    responsemodel.apiBody = responseData;
    responsemodel.statusCode = response.statusCode;
    if ([200, 201].contains(response.statusCode)) {
      // var gotdata = response.data;
      final parser = ParseMapValue(input: responseData);
      responsemodel.statusCode = response.statusCode;
      responsemodel.resultStatus = parser.fetchbool([
        'resultStatus',
        'resultstatus',
      ]);

      responsemodel.resultMsj = parser.fetchString([
        'resultMessage',
        'resultmessage',
        'ResultMsj',
      ]);

      responsemodel.resultData = parser.fetchdynamic([
        'resultData',
        'resultdata',
      ]);
    } else {
      responsemodel.resultMsj = errorMsjBucode(responsemodel.statusCode);
    }
  } on TimeoutException {
    responsemodel.resultMsj = "Connection timeout.";
  } catch (e) {
    responsemodel.resultMsj = e.toString();
  }

  if (printConsole) {
    (
      responsemodel.statusCode,
      responsemodel.resultMsj,
    ).toString().developerLog();
    // jsonEncode(apibody).developerLog();
  }

  if (showloading) {
    App.back();
  }

  return responsemodel;
}

String _withQueryParams(String url, Map<String, dynamic>? data) {
  if (data == null || data.isEmpty) {
    return url;
  }
  final uri = Uri.parse(url);
  final parms = <String, String>{};
  final allPram = {...uri.queryParameters, ...data};
  for (var x in allPram.entries) {
    if (x.value == null) {
      continue;
    }
    parms[x.key] = x.value.toString();
  }
  return Uri(
    scheme: uri.scheme,
    host: uri.host,
    port: uri.port,
    path: uri.path,
    queryParameters: parms,
    // fragment: uri.fragment,
  ).toString();
}

dynamic gtDecodedynamicdata(dynamic resultdata) {
  try {
    if (resultdata.runtimeType == String) {
      resultdata = jsonDecode(resultdata);
    }
  } catch (e) {
    debugPrint("e : _convertResultData");
  }

  return resultdata;
}

String errorMsjBucode(int code) {
  if ([401, 402].contains(code)) {
    return _statusCodeErrMsj[401] ?? '';
  }

  if (code >= 500 && code <= 599) {
    return "${_statusCodeErrMsj[500]}($code)";
  }

  if (code == 0) {
    return _statusCodeErrMsj[410] ?? '';
  }

  return _statusCodeErrMsj[code] ?? "Something is wrong.($code)";
}

Map<int, String> _statusCodeErrMsj = {
  101: 'Please update your app',
  200: 'Response received.',
  400: 'Bad Request',
  401: 'Unauthorized User',
  404: "Not Found",
  408: 'Server not responding',
  409: 'Network is slow.',
  410: 'Network not available.',
  500: 'Server error.',
};
