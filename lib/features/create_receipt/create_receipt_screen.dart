import 'package:flutter/material.dart';
import 'package:pos_billing/common/widgets/payment_mode_wid.dart';
import 'package:pos_billing/common/widgets/setting_button.dart';
import 'package:pos_billing/core/extensions/num_ex.dart';
import 'package:pos_billing/features/create_receipt/create_receipt_util.dart';

class CreateReceiptScreen extends StatefulWidget {
  const CreateReceiptScreen({super.key});

  static const String routeName = "/CreateReceiptScreen";

  @override
  State<CreateReceiptScreen> createState() => _CreateReceiptScreenState();
}

class _CreateReceiptScreenState extends State<CreateReceiptScreen> {
  late CreateReceiptUtil util;

  @override
  void initState() {
    util = CreateReceiptUtil(context: context)..onPageInit();
    super.initState();
  }

  @override
  void dispose() {
    util.onPageClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final primary = theme.primaryColor;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text("Receipt"),
            centerTitle: false,
            elevation: 5,

            actions: [
              const SettingButton(onTap: SettingButton.gotoStandSettings),
            ],
          ),
          ValueListenableBuilder(
            valueListenable: util.showItemsNotifier,
            builder: (context, child, _) {
              final showItems = util.showItemsNotifier.value;
              return SliverList(
                delegate: SliverChildListDelegate.fixed([
                  if (1 == 0)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: primary, width: 0.8),
                      ),
                      child: Row(
                        spacing: 8,
                        children: [
                          Expanded(
                            child: Text("Item", style: textTheme.titleSmall),
                          ),
                          SizedBox(
                            width: 30,
                            child: Text("Rate", style: textTheme.titleSmall),
                          ),

                          SizedBox(
                            width: 20 + 30 + 20 + 10,
                            child: Center(
                              child: Text(
                                "Quantity",
                                style: textTheme.titleSmall,
                              ),
                            ),
                          ),

                          SizedBox(
                            width: 45,
                            child: Align(
                              alignment: AlignmentGeometry.centerRight,
                              child: Text("Amount"),
                            ),
                          ),
                        ],
                      ),
                    ),

                  for (var (i, e) in showItems.indexed)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: (i.isEven ? Colors.grey.shade300 : null),
                        border: e.itemQuantity == 0
                            ? null
                            : Border.all(color: primary, width: 0.8),
                      ),
                      child: Row(
                        spacing: 8,
                        children: [
                          Expanded(
                            child: Text(
                              e.itemName,
                              style: textTheme.titleMedium?.copyWith(
                                color: e.itemQuantity == 0 ? null : primary,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 30,
                            child: Text(
                              e.itemRate.thousandText(),
                              style: textTheme.titleMedium,
                            ),
                          ),
                          InkWell(
                            onTap: () => util.onTapDecrement(e),
                            child: CircleAvatar(
                              radius: 20,
                              child: Icon(Icons.remove, size: 16),
                            ),
                          ),

                          SizedBox(
                            width: 30,
                            child: Center(
                              child: Text(
                                e.itemQuantity.thousandText(),
                                style: textTheme.titleMedium,
                              ),
                            ),
                          ),

                          InkWell(
                            onTap: () => util.onTapIncrement(e),
                            child: CircleAvatar(
                              radius: 20,
                              child: Icon(Icons.add, size: 16),
                            ),
                          ),

                          SizedBox(
                            width: 45,
                            child: Align(
                              alignment: AlignmentGeometry.centerRight,
                              child: Text(
                                e.itemAmount.thousandText(),
                                style: textTheme.titleMedium,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ]),
              );
            },
          ),
        ],
      ),

      bottomNavigationBar: Material(
        elevation: 20,

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ValueListenableBuilder(
              valueListenable: util.showItemsNotifier,
              builder: (context, showItems, child) {
                final (qty, amt) = util.getGrandTotal();
                return Container(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    spacing: 5,
                    children: [
                      Row(
                        spacing: 8,
                        children: [
                          Expanded(
                            child: Text(
                              "Total Qty.",
                              style: textTheme.titleMedium,
                            ),
                          ),
                          Text(
                            qty.thousandText(),
                            style: textTheme.titleMedium,
                          ),
                        ],
                      ),
                      Row(
                        spacing: 8,
                        children: [
                          Expanded(
                            child: Text(
                              "Total Amount.",
                              style: textTheme.titleLarge,
                            ),
                          ),
                          Text(
                            "Rs. ${amt.thousandText()}",
                            style: textTheme.titleLarge,
                          ),
                        ],
                      ),

                      ValueListenableBuilder(
                        valueListenable: util.paymentModeNotifier,
                        builder: (context, paymentMode, child) {
                          return PaymentModeRadioSelection(
                            selectedValue: paymentMode,
                            onChange: util.onPaymentModeChange,
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                spacing: 16,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: util.onTapClear,
                      child: Text("Clear"),
                    ),
                  ),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => util.printReceipt(),
                      child: Text("Print"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
