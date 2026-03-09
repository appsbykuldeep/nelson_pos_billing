import 'package:flutter/material.dart';
import 'package:pos_billing/common/models/item/item_info.dart';
import 'package:pos_billing/common/singletons/app.dart';

class AddUpdateItemDialogue {
  static const String _routeName = "/AddUpdateItemDialogue";

  static Future show(BuildContext context, ItemInfo? preInfo) async {
    return await showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Material(child: _AddUpdateItem(preInfo: preInfo)),
      ),
      barrierColor: Colors.black38,
      barrierDismissible: true,

      routeSettings: RouteSettings(name: _routeName),
    );
  }

  static void hide() {
    App.removeAllRouteByName(_routeName);
  }
}

class _AddUpdateItem extends StatefulWidget {
  final ItemInfo? preInfo;
  const _AddUpdateItem({required this.preInfo});

  @override
  State<_AddUpdateItem> createState() => _AddUpdateItemState();
}

class _AddUpdateItemState extends State<_AddUpdateItem> {
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController amtCtrl = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    nameCtrl.text = widget.preInfo?.itemName ?? "";
    amtCtrl.text = widget.preInfo?.itemRate.toString() ?? "";
    super.initState();
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    amtCtrl.dispose();
    super.dispose();
  }

  Future<void> onTapSubmit() async {
    final valid = formKey.currentState?.validate() ?? false;
    if (!valid) {
      return;
    }
    App.back();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                (widget.preInfo == null ? "Add Item" : "Update Item"),
                style: theme.textTheme.titleLarge,
              ),
            ),

            TextFormField(
              controller: nameCtrl,
              maxLength: 50,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.visiblePassword,
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.length < 3) {
                  return "Please enter valid name";
                }
                return null;
              },
              decoration: InputDecoration(
                counterText: '',
                hintText: '',
                labelText: 'Item Name',
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),
            TextFormField(
              controller: amtCtrl,
              maxLength: 9,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter rate";
                }
                if (num.tryParse(value) == null) {
                  return "Enter valid rate";
                }
                return null;
              },
              decoration: InputDecoration(
                counterText: '',
                hintText: '',
                labelText: 'Rate',
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),
            FilledButton(onPressed: onTapSubmit, child: Text("Submit")),
          ],
        ),
      ),
    );
  }
}
