import 'package:flutter/material.dart';
import 'package:pos_billing/config/constants/assets.dart';

class NoRecordfound extends StatelessWidget {
  final double? marginTop;
  final String message;
  const NoRecordfound({
    super.key,
    this.marginTop,
    this.message = "\n\nOops ! No records found.",
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    final height = marginTop ?? size.height * 0.25;
    return SizedBox(
      width: size.width,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, height, 20, 40),
        child: Text.rich(
          TextSpan(
            children: [
              WidgetSpan(
                child: Image.asset(Assets.imagesNoRecord, height: 180),
              ),
              if (message.isNotEmpty)
                TextSpan(
                  text: message,
                  style: TextStyle(
                    color: theme.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
