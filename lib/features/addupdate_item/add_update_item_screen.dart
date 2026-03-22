import 'package:flutter/material.dart';
import 'package:pos_billing/common/classes/socketio_handler.dart';
import 'package:pos_billing/common/dialogues/confirmation.dart';
import 'package:pos_billing/common/dialogues/show_loading.dart';
import 'package:pos_billing/common/models/item/item_info.dart';
import 'package:pos_billing/common/singletons/app.dart';
import 'package:pos_billing/common/singletons/login_ctrl.dart';
import 'package:pos_billing/config/constants/soket_events.dart';
import 'package:pos_billing/core/extensions/string_ext.dart';
import 'package:pos_billing/core/extensions/textediting_ext.dart';

class AddUpdateItemScreen extends StatefulWidget {
  final ItemInfo? preInfo;
  const AddUpdateItemScreen({super.key, required this.preInfo});

  static const String routeName = "/AddUpdateItemScreen";

  @override
  State<AddUpdateItemScreen> createState() => _AddUpdateItemScreenState();
}

class _AddUpdateItemScreenState extends State<AddUpdateItemScreen> {
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController nameEngCtrl = TextEditingController();
  TextEditingController amtCtrl = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final login = LoginUtil.instance;

  @override
  void initState() {
    nameCtrl.text = widget.preInfo?.itemName ?? "";
    nameEngCtrl.text = widget.preInfo?.itemNameInEnglish ?? "";
    amtCtrl.text = widget.preInfo?.itemRate.toString() ?? "";
    super.initState();
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    amtCtrl.dispose();
    nameEngCtrl.dispose();
    super.dispose();
  }

  Future<void> onTapSubmit() async {
    final valid = formKey.currentState?.validate() ?? false;
    if (!valid) {
      return;
    }

    if (!await makeconfirmation()) {
      return;
    }

    final data = {
      "itemId": widget.preInfo?.itemId,
      "itemName": nameCtrl.trimText,
      "itemNameInEnglish": nameEngCtrl.trimText,
      "itemRate": amtCtrl.trimText,
      "siteId": login.userNotifier.value.siteId,
      "userId": login.userNotifier.value.userId,
    };
    LoadingDialogue.show();

    final resp = await SocketIoHandler.emitWithResponseForCurrentUser(
      SoketEvents.addUpdateItems,
      data,
    );
    LoadingDialogue.hide();
    if (resp.resultStatus) {
      App.back(true);
    } else {
      resp.resultMessage.showToast;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text((widget.preInfo == null ? "Add Item" : "Update Item")),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16, 10, 16, 60),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 16,
            children: [
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
                controller: nameEngCtrl,
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
                  labelText: 'Item English Name',
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
      ),
    );
  }
}
