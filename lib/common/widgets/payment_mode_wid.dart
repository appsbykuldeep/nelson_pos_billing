import 'package:flutter/material.dart';
import 'package:pos_billing/config/enums/payment_mode.dart';

class PaymentModeRadioSelection extends StatelessWidget {
  final PaymentMode selectedValue;
  final ValueChanged<PaymentMode> onChange;
  const PaymentModeRadioSelection({
    super.key,
    required this.selectedValue,
    required this.onChange,
  });

  // void onTapRadio(PaymentMode mode) {
  //   onChange.call(defPaymentMode.findById(mode.id.toString()));
  // }

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        Expanded(
          child: PaymentModeRadio(
            mode: PaymentMode.cash,
            selectedMode: selectedValue,
            onTap: onChange,
          ),
        ),
        Expanded(
          child: PaymentModeRadio(
            mode: PaymentMode.online,
            selectedMode: selectedValue,
            onTap: onChange,
          ),
        ),
      ],
    );
  }
}

class PaymentModeRadio extends StatelessWidget {
  final PaymentMode mode;
  final PaymentMode selectedMode;
  final ValueChanged<PaymentMode> onTap;
  const PaymentModeRadio({
    super.key,
    required this.mode,
    required this.selectedMode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedMode == mode;
    final primary = Theme.of(context).primaryColor;
    final color = isSelected ? primary : Colors.black;
    return InkWell(
      onTap: () => onTap.call(mode),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(width: 0.5),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text.rich(
                TextSpan(
                  children: [
                    WidgetSpan(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Icon(mode.iconData, color: color),
                      ),
                      alignment: PlaceholderAlignment.middle,
                    ),
                    TextSpan(
                      text: mode.lable,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: color,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ],
                ),
                maxLines: 1,
              ),
            ),
            if (isSelected)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Icon(Icons.done, color: color, size: 24),
              ),
          ],
        ),
      ),
    );
  }
}
