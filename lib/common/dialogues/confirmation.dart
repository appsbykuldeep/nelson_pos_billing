import 'package:flutter/material.dart';
import 'package:pos_billing/common/singletons/app.dart';
import 'package:pos_billing/common/singletons/routeobserver.dart';
import 'package:pos_billing/common/widgets/general_styled_text.dart';
import 'package:pos_billing/common/widgets/keyboard_shortcut.dart';

Future<bool> makeconfirmation({
  String titel = "Confirmation !!!",
  String content = 'Are you sure ?',
  // Widget? contentWid,
  Color? contentColor,
  bool yestobutton = true,
  bool useStyledText = true,
  TextStyle? textStyle,
}) async {
  final context = App.context;

  if (RouteObserverService.isRouteInTree(_ConfirmationSection.routeName)) {
    return false;
  }

  final status = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    routeSettings: const RouteSettings(name: _ConfirmationSection.routeName),
    builder: (context) {
      return _ConfirmationSection(
        titel: titel,
        content: content,
        contentColor: contentColor,
        yestobutton: yestobutton,
        useStyledText: yestobutton,
        textStyle: textStyle,
      );
    },
  );

  return status ?? false;
}

class _ConfirmationSection extends StatefulWidget {
  final String titel;
  final String content;
  final Color? contentColor;
  final bool yestobutton;
  final bool useStyledText;
  final TextStyle? textStyle;

  const _ConfirmationSection({
    required this.titel,
    required this.content,
    required this.contentColor,
    required this.yestobutton,
    required this.useStyledText,
    required this.textStyle,
  });

  static const String routeName = "/confirmation";

  @override
  State<_ConfirmationSection> createState() => __ConfirmationSectionState();
}

class __ConfirmationSectionState extends State<_ConfirmationSection> {
  FocusNode screenFocus = FocusNode();

  @override
  void dispose() {
    screenFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    late Widget yes;
    late Widget no;

    if (widget.yestobutton) {
      yes = ElevatedButton(
        autofocus: true,
        onPressed: () {
          Navigator.pop(context, true);
        },
        child: const Text('Yes'),
      );

      no = OutlinedButton(
        onPressed: () {
          Navigator.pop(context, false);
        },
        child: const Text('NO'),
      );
    } else {
      yes = OutlinedButton(
        onPressed: () {
          Navigator.pop(context, true);
        },
        child: const Text('Yes'),
      );

      no = ElevatedButton(
        autofocus: true,
        onPressed: () {
          Navigator.pop(context, false);
        },
        child: const Text('NO'),
      );
    }

    final style = theme.textTheme.bodyMedium?.copyWith(
      color: widget.contentColor,
      fontWeight: FontWeight.w500,
    );

    return KeyboardShortcut(
      debugLabel: "_ConfirmationSection",
      focusNode: screenFocus,
      onPressSpace: () {
        Navigator.pop(context, false);
      },
      onPressEnter: () {
        Navigator.pop(context, true);
      },
      child: AlertDialog(
        backgroundColor: theme.scaffoldBackgroundColor,
        title: Text(
          widget.titel,
          style: theme.textTheme.titleMedium?.copyWith(color: primaryColor),
        ),
        content: widget.useStyledText
            ? GeneralStyledText(
                text: widget.content,
                textStyle: widget.textStyle ?? style,
              )
            : Text(widget.content, softWrap: true, style: style),
        actions: [
          no,
          yes,
          // ElevatedButton(
          //   style: ElevatedButton.styleFrom(
          //     backgroundColor: !yestobutton
          //         ? primaryColor
          //         : Colors.transparent.withOpacity(0.5),
          //     elevation: !yestobutton ? 5 : 0,
          //   ),
          //   onPressed: () {
          //     Navigator.pop(context, false);
          //   },
          //   child: Text(
          //     'NO',
          //     style: TextStyle(
          //       color: surface,
          //       fontSize: 16,
          //     ),
          //   ),
          // ),
          // ElevatedButton(
          //   style: ElevatedButton.styleFrom(
          //     backgroundColor:
          //         yestobutton ? primaryColor : Colors.transparent,
          //     elevation: yestobutton ? 5 : 0,
          //   ),
          //   onPressed: () {
          //     Navigator.pop(context, true);
          //   },
          //   child: Text(
          //     'Yes',
          //     style: TextStyle(
          //       color: !yestobutton ? primaryColor : surface,
          //       fontSize: 16,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
