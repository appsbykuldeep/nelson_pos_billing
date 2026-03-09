import 'package:flutter/material.dart';
import 'package:pos_billing/common/singletons/app.dart';
import 'package:pos_billing/config/enums/app_fontfamily.dart';

class AppNameWid extends StatelessWidget {
  final double fontSize;
  const AppNameWid({super.key, this.fontSize = 16});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final secondaryColor = theme.colorScheme.secondary;
    // final tagfontSize = fontSize * 0.75;

    return Text.rich(
      TextSpan(
        children: [
          if (App.company.isParkingTicket)
            TextSpan(
              text: "Parking",
              style: TextStyle(
                fontFamily: AppFontFamily.pacifico.lable,
                fontWeight: FontWeight.w500,
                letterSpacing: 2.5,
                color: primaryColor,
                fontSize: fontSize,
              ),

              children: [
                TextSpan(
                  text: " Ticket",
                  style: TextStyle(color: secondaryColor),
                ),
              ],
            ),

          if (App.company.isParkingBoss)
            TextSpan(
              text: "Parking",
              style: TextStyle(
                fontFamily: AppFontFamily.pacifico.lable,
                fontWeight: FontWeight.w500,
                letterSpacing: 2.5,
                color: primaryColor,
                fontSize: fontSize,
              ),

              children: [
                TextSpan(
                  text: " Boss",
                  style: TextStyle(color: secondaryColor),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class AppNameWithTaglineWid extends StatelessWidget {
  final double fontSize;
  final double tagfontSize;
  const AppNameWithTaglineWid({
    super.key,
    this.fontSize = 16,
    required this.tagfontSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final secondaryColor = theme.colorScheme.secondary;

    if (!App.company.isParkingTicket) {
      return const SizedBox();
    }

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: "Parking",
            style: TextStyle(
              fontFamily: AppFontFamily.pacifico.lable,
              fontWeight: FontWeight.w500,
              letterSpacing: 2.5,
              color: primaryColor,
              fontSize: fontSize,
            ),

            children: [
              TextSpan(
                text: " Ticket",
                style: TextStyle(color: secondaryColor),
              ),
            ],
          ),
          const TextSpan(text: "\n ", style: TextStyle(fontSize: 20)),

          TextSpan(
            style: TextStyle(
              color: secondaryColor,
              fontSize: tagfontSize,
              fontWeight: FontWeight.w500,
            ),
            children: [
              const TextSpan(text: "\u2022 "),
              const TextSpan(text: "It Makes Parking "),
              TextSpan(
                text: "Easy",
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const TextSpan(text: " \u2022"),
            ],
          ),
        ],
      ),

      textAlign: TextAlign.center,
    );
  }
}
