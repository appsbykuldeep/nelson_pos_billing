import 'package:flutter/material.dart';
import 'package:pos_billing/common/singletons/app.dart';
import 'package:pos_billing/common/singletons/vibrate_handler.dart';
import 'package:pos_billing/common/widgets/general_styled_text.dart';
import 'package:pos_billing/common/widgets/keyboard_shortcut.dart';

class AlertDialogue {
  AlertDialogue._();

  static const String routeName = "/AlertDialogue";

  static Future<void> show(
    String message, {
    bool vibrate = true,
    String title = "Alert",
    VoidCallback? onTapOk,
    BuildContext? context,
  }) async {
    if (message.isEmpty) {
      return;
    }
    if (vibrate) {
      VibrateHandler.warning();
    }

    return showDialog(
      context: context ?? App.context,
      builder: (context) =>
          _AlertSection(title: title, message: message, onTapOk: onTapOk),
      barrierDismissible: false,
      routeSettings: const RouteSettings(name: routeName),
    );
  }

  static void hide([BuildContext? context]) {
    FocusScope.of(context ?? App.context).unfocus();
    // Navigator.pop(App.context);
    App.removeRouteByName(routeName);
  }
}

class _AlertSection extends StatefulWidget {
  final String title;
  final String message;
  final VoidCallback? onTapOk;
  const _AlertSection({
    required this.title,
    required this.message,
    required this.onTapOk,
  });

  @override
  State<_AlertSection> createState() => _AlertSectionState();
}

class _AlertSectionState extends State<_AlertSection> {
  FocusNode screenFocus = FocusNode();

  @override
  void dispose() {
    screenFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return KeyboardShortcut(
      focusNode: screenFocus,
      onPressSpace: () {
        AlertDialogue.hide(context);
      },
      onPressEnter: () {
        AlertDialogue.hide(context);
      },
      onPressEscape: () {
        AlertDialogue.hide(context);
      },
      child: AlertDialog(
        title: Text(
          widget.title,
          style: TextStyle(
            fontSize: 16,
            color: theme.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: GeneralStyledText(
          text: widget.message,
          textStyle: theme.textTheme.bodyMedium,
        ),
        actions: [
          OutlinedButton(
            autofocus: true,
            onPressed: widget.onTapOk ?? AlertDialogue.hide,
            child: const Text(
              "OK",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
