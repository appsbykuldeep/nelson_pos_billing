import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pos_billing/common/widgets/general_styled_text.dart';

class CutomTextField extends StatelessWidget {
  final String? lable;
  final Widget? lableWidget;
  final Widget? bottomWidget;
  final String hint;
  final TextEditingController controller;
  final bool canEdit;
  final bool enabled;
  final bool isVisible;
  final bool ispassword;
  final int maxLines;
  final int maxLength;
  final double bottomSpace;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChange;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String? val)? validator;
  final Widget? prefixIcon;
  const CutomTextField({
    super.key,
    this.lable,
    this.lableWidget,
    required this.hint,
    required this.controller,
    this.enabled = true,
    this.canEdit = true,
    this.isVisible = true,
    this.ispassword = false,
    this.maxLength = 50,
    this.maxLines = 1,
    this.textInputType,
    this.textInputAction,
    this.bottomSpace = 16,
    this.onChange,
    this.inputFormatters,
    this.validator,
    this.bottomWidget,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible) {
      return const SizedBox.shrink();
    }
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ?lableWidget,
        if (lableWidget == null && lable != null)
          GeneralStyledText(
            text: lable!,
            textStyle: theme.textTheme.bodyMedium,
          ),
        // Text(
        //   lable!,
        //   style: context.bodyMedium,
        // ),
        SizedBox(height: 5),

        TextFormField(
          textInputAction: textInputAction ?? TextInputAction.next,
          keyboardType: textInputType ?? TextInputType.name,
          maxLength: maxLength,
          enabled: enabled,
          readOnly: !canEdit,
          textCapitalization: TextCapitalization.words,
          maxLines: maxLines,
          obscureText: ispassword,
          controller: controller,
          onChanged: onChange,
          inputFormatters: inputFormatters,
          validator: validator,
          style: const TextStyle(letterSpacing: 0.85),
          decoration: InputDecoration(
            isDense: true,
            hintText: hint,
            counterText: "",
            prefix: prefixIcon,
          ),
        ),
        ?bottomWidget,
        SizedBox(height: bottomSpace),
      ],
    );
  }
}
