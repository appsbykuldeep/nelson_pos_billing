import 'package:flutter/material.dart';

class DataCellWid extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Alignment? alignment;
  final TextAlign? textAlign;
  const DataCellWid(
    this.text, {
    super.key,
    this.style,
    this.alignment,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    final cell = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      child: Text(text, style: style, textAlign: textAlign),
    );
    if (alignment != null) {
      return Align(alignment: alignment!, child: cell);
    }

    return cell;
  }
}
