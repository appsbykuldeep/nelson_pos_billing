import 'package:flutter/services.dart';

final doubleInputFormatters = [
  FilteringTextInputFormatter.allow(RegExp('[.0-9]')),
];
final intInputFormatters = [FilteringTextInputFormatter.allow(RegExp('[0-9]'))];
final intInputFormattersWithNegative = [
  FilteringTextInputFormatter.allow(RegExp('-?[0-9]')),
];
final vhicleNumberInputFormatters = [
  FilteringTextInputFormatter.allow(RegExp(r'[0-9a-zA-Z]')),
];

final doubleAmountInputFormattersWithSign = [
  FilteringTextInputFormatter.allow(RegExp(r'(\-|\+)?(\d*)(\.)?(\d){0,3}')),
];
final intAmountInputFormattersWithSign = [
  FilteringTextInputFormatter.allow(RegExp(r'(\-|\+)?(\d*)')),
];

List<FilteringTextInputFormatter> get upiIdsInputFormatters => [
  FilteringTextInputFormatter.allow(RegExp(r'([A-Za-z0-9\@\_\-\.\n]*)')),
];

final userNameInputFormatters = [
  FilteringTextInputFormatter.allow(RegExp('[0-9a-zA-Z-@_.#]')),
];

final alphanumaricInputFormatters = [
  FilteringTextInputFormatter.allow(RegExp('[0-9a-zA-Z]')),
];

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final String upper = newValue.text.toUpperCase();

    // Try to preserve cursor offset
    final int baseOffset = newValue.selection.baseOffset;
    final int extentOffset = newValue.selection.extentOffset;
    final int newLength = upper.length;

    // Calculate new offsets but clamp them to valid range
    int newBase = baseOffset.clamp(0, newLength);
    int newExtent = extentOffset.clamp(0, newLength);

    return TextEditingValue(
      text: upper,
      selection: TextSelection(baseOffset: newBase, extentOffset: newExtent),
      // clear composing to avoid IME issues on web/desktop
      composing: TextRange.empty,
    );
  }
}
