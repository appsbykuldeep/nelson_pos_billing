import 'package:flutter/material.dart';
import 'package:pos_billing/common/dialogues/date_pickers.dart';
import 'package:pos_billing/core/extensions/app_context_ext.dart';
import 'package:pos_billing/core/extensions/app_shortcut.dart';

class AppTitleText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color? color;
  const AppTitleText(this.text, {super.key, this.color, this.fontSize = 18});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        color: color ?? context.primaryColor,
        // fontFamily: "Pacifico",
        letterSpacing: null,
      ),
    );
  }
}

class AppTitleWithDateRange extends StatelessWidget {
  final DateTimeRange dateTimeRange;
  final String title;
  final ValueChanged<DateTimeRange> onRangeSelection;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final double titleSize;
  const AppTitleWithDateRange({
    super.key,
    required this.dateTimeRange,
    required this.title,
    required this.onRangeSelection,
    required this.firstDate,
    this.lastDate,
    this.titleSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final (start, end) = dateTimeRange.dateRangePartsText;
    return InkWell(
      onTap: () async {
        final date = await showDateRangePickerDialogue(
          iniitalDateRange: dateTimeRange,
          firstDate: firstDate,
          lastDate: lastDate,
        );

        if (date != null) {
          onRangeSelection.call(date);
        }
      },
      child: Text.rich(
        TextSpan(
          text: '$title\n',

          // style: const TextStyle(
          //   fontSize: 13,
          //   fontWeight: FontWeight.bold,
          // ),
          style: TextStyle(
            color: primaryColor,
            fontSize: titleSize,
            // fontWeight: FontWeight.bold,
            // fontFamily: "Pacifico",
            letterSpacing: null,
          ),
          children: [
            TextSpan(
              style: TextStyle(
                fontSize: 9,
                color: context.onSurface,
                fontWeight: FontWeight.normal,
                fontFamily: "Poppins",
                letterSpacing: 0,
              ),
              text: "(",
              children: [
                TextSpan(
                  text: start,
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                if (end != null) ...[
                  const TextSpan(text: " To "),
                  TextSpan(
                    text: end,
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
                const TextSpan(text: ")"),
              ],
            ),
          ],
        ),
        style: theme.appBarTheme.titleTextStyle,
      ),
    );
  }
}

class AppTitleWithDateTimeRange extends StatelessWidget {
  final DateTimeRange dateTimeRange;
  final String title;
  final ValueChanged<DateTimeRange> onRangeSelection;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final double titleSize;
  const AppTitleWithDateTimeRange({
    super.key,
    required this.dateTimeRange,
    required this.title,
    required this.onRangeSelection,
    this.firstDate,
    this.lastDate,
    this.titleSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final (start, end) = dateTimeRange.dateTimeRangePartsText;
    return InkWell(
      onTap: () async {
        final date = await showDateTimeRangePickerDialogue(
          iniitalDateRange: dateTimeRange,
          firstDate: firstDate,
          lastDate: lastDate,
        );

        if (date != null) {
          onRangeSelection.call(date);
        }
      },
      child: Text.rich(
        TextSpan(
          text: '$title\n',

          // style: const TextStyle(
          //   fontSize: 13,
          //   fontWeight: FontWeight.bold,
          // ),
          style: TextStyle(
            color: primaryColor,
            fontSize: titleSize,
            // fontWeight: FontWeight.bold,
            // fontFamily: "Pacifico",
            letterSpacing: null,
          ),
          children: [
            TextSpan(
              style: TextStyle(
                fontSize: 9,
                color: context.onSurface,
                fontWeight: FontWeight.normal,
                fontFamily: "Poppins",
                letterSpacing: 0,
              ),
              text: "(",
              children: [
                TextSpan(
                  text: start,
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                if (end != null) ...[
                  const TextSpan(text: " To "),
                  TextSpan(
                    text: end,
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
                const TextSpan(text: ")"),
              ],
            ),
          ],
        ),
        style: theme.appBarTheme.titleTextStyle,
      ),
    );
  }
}
