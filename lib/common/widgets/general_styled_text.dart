import 'package:flutter/material.dart';
import 'package:styled_text/styled_text.dart';

class GeneralStyledText extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final Map<String, StyledTextTag>? othertags;
  final TextAlign? textAlign;
  const GeneralStyledText({
    super.key,
    required this.text,
    this.textStyle,
    this.othertags,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    final style = textStyle ?? const TextStyle();
    final baseTags = {
      'b': StyledTextTag(style: style.copyWith(fontWeight: FontWeight.bold)),
      'i': StyledTextTag(style: style.copyWith(fontStyle: FontStyle.italic)),
      'm': StyledTextTag(
        style: style.copyWith(
          color: Colors.red.shade600,
          fontWeight: FontWeight.bold,
        ),
      ),
      'mn': StyledTextTag(
        style: style.copyWith(
          color: Colors.red.shade600,
          fontWeight: FontWeight.normal,
        ),
      ),
      'gn': StyledTextTag(
        style: style.copyWith(
          color: Colors.green.shade600,
          fontWeight: FontWeight.normal,
        ),
      ),

      'mb': StyledTextTag(
        style: style.copyWith(
          color: Colors.red.shade600,
          fontWeight: FontWeight.bold,
        ),
      ),
      'msn': StyledTextTag(
        style: style.copyWith(
          color: Colors.red.shade600,
          fontWeight: FontWeight.normal,
          fontSize: 9,
        ),
      ),
      'gb': StyledTextTag(
        style: style.copyWith(
          color: Colors.green.shade600,
          fontWeight: FontWeight.bold,
        ),
      ),

      'small': StyledTextTag(style: style.copyWith(fontSize: 9)),
    };
    if (othertags != null) {
      baseTags.addAll(othertags!);
    }
    return StyledText(
      text: text,
      tags: baseTags,
      style: style,

      textAlign: textAlign,
    );
  }
}
