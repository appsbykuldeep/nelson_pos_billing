import 'package:flutter/material.dart';
import 'package:pos_billing/common/singletons/app.dart';
import 'package:pos_billing/common/singletons/vibrate_handler.dart';

class LoginConfirmationDialogue {
  LoginConfirmationDialogue._();

  static const String routeName = "/LoginConfirmationDialogue";

  static Future<bool> show(String message, {bool vibrate = true}) async {
    if (vibrate) {
      VibrateHandler.warning();
    }

    final status = await showDialog<bool>(
      context: App.context,
      builder: (context) {
        final theme = Theme.of(context);
        return AlertDialog(
          title: Text(
            "Alert",
            style: TextStyle(
              fontSize: 16,
              color: theme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(message, style: theme.textTheme.bodyMedium),
          actions: [
            OutlinedButton(
              autofocus: true,
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text(
                "Login Here",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text(
                "OK",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
      barrierDismissible: false,
      routeSettings: const RouteSettings(name: routeName),
    );

    return status ?? false;
  }

  static void hide() {
    // Navigator.pop(App.context);
    App.removeRouteByName(routeName);
  }
}
