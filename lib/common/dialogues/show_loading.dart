import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pos_billing/common/singletons/app.dart';
import 'package:pos_billing/config/enums/api_progess.dart';

class LoadingDialogue {
  LoadingDialogue._();

  static const String routeName = "/LoadingDialogue";

  static Future<void> show({String lable = "Working..."}) async {
    final card = Material(
      color: Colors.transparent,
      child: Center(
        child: Card(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 20),
                ValueListenableBuilder(
                  valueListenable: _progessValueNotifier,
                  builder: (context, progessValue, child) {
                    final value = _percentValue(progessValue);
                    final valStr = _percentStr(value);
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 55,
                          width: 55,
                          child: CircularProgressIndicator(value: value),
                        ),
                        Text(
                          valStr,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 9,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: 8),
                ValueListenableBuilder(
                  valueListenable: _progessStatusNotifier,
                  builder: (context, status, child) {
                    return Text(
                      status?.label ?? lable,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    );
                  },
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );

    return showDialog(
      context: App.context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: kDebugMode
              ? GestureDetector(onLongPress: hide, child: card)
              : card,
        );
      },
      barrierDismissible: false,
      useSafeArea: false,
      routeSettings: const RouteSettings(name: routeName),
    );
  }

  static final ValueNotifier<double> _progessValueNotifier = ValueNotifier(0);

  static final ValueNotifier<ApiProgessStatus?> _progessStatusNotifier =
      ValueNotifier(null);

  static double? _percentValue(double val) =>
      (val <= 0 || val >= 1) ? null : val;

  static String _percentStr(double? val) =>
      val == null ? "" : "${(val * 100).toStringAsFixed(1)}%";

  static void setProgressValue(double? val) {
    _progessValueNotifier.value = (val ?? 0).clamp(0, 1);
  }

  static void setProgressStatus([ApiProgessStatus? val]) {
    _progessStatusNotifier.value = val;
  }

  static void resetStatus() {
    _progessValueNotifier.value = 0;
    _progessStatusNotifier.value = null;
  }

  static void setProgressValueV2(num count, num total) {
    if (total > 0) {
      _progessValueNotifier.value = (count / total).clamp(0, 1);
    } else {
      _progessValueNotifier.value = 0;
    }
  }

  static void hide() {
    App.removeRouteByName(routeName);
    resetStatus();
  }

  static void hideAll() {
    App.removeAllRouteByName(routeName);
    resetStatus();
  }
}
