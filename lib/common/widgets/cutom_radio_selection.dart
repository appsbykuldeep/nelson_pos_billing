import 'package:flutter/material.dart';

class CustomRadioSelection<T> extends StatelessWidget {
  final String label;
  final T value;
  final T groupValue;
  final ValueChanged<T> onTap;
  final TextStyle? textStyle;
  const CustomRadioSelection({
    super.key,
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onTap,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => onTap.call(value),
      child: Text.rich(
        TextSpan(
          children: [
            WidgetSpan(
              child: Icon(
                isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                size: 22,
                color: isSelected ? theme.primaryColor : null,
              ),
            ),
            TextSpan(
              text: "\t\t$label",
              style:
                  textStyle ??
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

class ChargeTypeRadioSelection<T> extends StatelessWidget {
  final String label;
  final String description;
  final T value;
  final T groupValue;
  final ValueChanged<T>? onTap;
  final TextStyle? textStyle;
  const ChargeTypeRadioSelection({
    super.key,
    required this.label,
    required this.description,
    required this.value,
    required this.groupValue,
    required this.onTap,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap == null ? null : () => onTap?.call(value),
      child: Text.rich(
        TextSpan(
          children: [
            WidgetSpan(
              child: Icon(
                isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                size: 22,
                color: isSelected ? theme.primaryColor : null,
              ),
              alignment: PlaceholderAlignment.middle,
            ),
            TextSpan(
              text: "\t\t$label",
              style:
                  textStyle ??
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                  text: "\n$description",
                  style: const TextStyle(
                    fontSize: 8.5,
                    color: Colors.grey,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
