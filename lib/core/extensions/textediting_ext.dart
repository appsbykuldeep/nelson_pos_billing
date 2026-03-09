import 'package:flutter/material.dart';

extension KDTextEditingCtrlExt on TextEditingController {
  String get trimText => text.trim();
  String get trimLowerText => text.trim().toLowerCase();
  bool get isEmpty => trimText.isEmpty;
  String? get nullOnEmpty => isEmpty ? null : trimText;

  num get toNumber => num.tryParse(trimText) ?? 0;
  int get toInt => int.tryParse(trimText) ?? 0;
  double get toDouble => double.tryParse(trimText) ?? 0;

  void setTextSilently(String newText) {
    value = value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
      composing: TextRange.empty,
    );
  }

  void replaceLastWordWith(String lastWord, String replacement) {
    final text = value.text;
    final textLength = text.length;

    int cursor = value.selection.baseOffset;

    // Normalize cursor
    if (cursor < 0 || cursor > textLength) {
      cursor = textLength;
    }

    // If lastWord is empty, just insert
    if (lastWord.isEmpty) {
      insertAtCursor(replacement);
      return;
    }

    // Calculate start index of lastWord
    int start = cursor - lastWord.length;

    // Safety clamp
    if (start < 0 || start > cursor) {
      insertAtCursor(replacement);
      return;
    }

    // Validate substring match (important!)
    final actual = text.substring(start, cursor);
    if (actual != lastWord) {
      // Fallback: do not corrupt text
      insertAtCursor(replacement);
      return;
    }

    final newText = text.replaceRange(start, cursor, replacement);

    value = value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: start + replacement.length),
      composing: TextRange.empty,
    );
  }

  void insertAtCursor(String insertText) {
    final textValue = value.text;
    final textLength = textValue.length;

    int start = value.selection.start;
    int end = value.selection.end;

    // Normalize invalid selection
    if (start < 0 || start > textLength) {
      start = textLength;
    }
    if (end < 0 || end > textLength) {
      end = textLength;
    }

    // Ensure correct order
    if (start > end) {
      final temp = start;
      start = end;
      end = temp;
    }

    final newText = textValue.replaceRange(start, end, insertText);

    value = value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: start + insertText.length),
      composing: TextRange.empty,
    );
  }

  void putCursonInLast() {
    // selection = TextSelection.fromPosition(TextPosition(offset: text.length));
    Future.microtask(() {
      selection = TextSelection.collapsed(offset: text.length);
    });
  }
}
