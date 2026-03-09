import 'package:flutter/material.dart';
import 'package:pos_billing/common/classes/socketio_handler.dart';
import 'package:pos_billing/common/dialogues/confirmation.dart';
import 'package:pos_billing/common/dialogues/show_loading.dart';
import 'package:pos_billing/common/singletons/app.dart';
import 'package:pos_billing/common/singletons/internet_connectivity.dart';
import 'package:pos_billing/common/singletons/login_ctrl.dart';
import 'package:pos_billing/common/widgets/desktop_wraper_wid.dart';
import 'package:pos_billing/common/widgets/keyboard_shortcut.dart';
import 'package:pos_billing/config/constants/soket_events.dart';
import 'package:pos_billing/core/extensions/string_ext.dart';
import 'package:pos_billing/core/extensions/textediting_ext.dart';
import 'package:pos_billing/features/login/login_screen.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  static const String routeName = "/ChangePassword";

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  TextEditingController currentPwCtrl = TextEditingController();
  TextEditingController newPwCtrl = TextEditingController();
  TextEditingController confirmPwCtrl = TextEditingController();
  final login = LoginUtil.instance;

  Future<void> onUpdateClick() async {
    if (currentPwCtrl.trimText.isEmpty) {
      "Fill current password.".showToast;
      return;
    }

    if (newPwCtrl.trimText.isEmpty) {
      ("Fill new password.").showToast;
      return;
    }
    if (confirmPwCtrl.trimText.isEmpty) {
      "Fill confirm password.".showToast;
      return;
    }

    // if (currentPwCtrl.text.toMd5 != "".boxUserpw.toMd5) {
    //   "Invalid current password.".gtShowtost;
    //   return;
    // }
    if (newPwCtrl.text != confirmPwCtrl.text) {
      "Confirm password not matched.".showToast;
      return;
    }

    if (confirmPwCtrl.text.trim().isWeekPW) {
      "Password strength is too week.".showToast;
      return;
    }

    if (InternetConnectivity.checkNotAvailableAndShowDialogue()) {
      return;
    }

    if (!await makeconfirmation()) return;
    var body = {
      "userId": login.userId,
      "oldPW": currentPwCtrl.trimText.toMd5,
      "newPW": newPwCtrl.trimText.toMd5,
    };
    LoadingDialogue.show();

    final resp = await SocketIoHandler.emitWithResponseForCurrentUser(
      SoketEvents.changePassword,
      body,
    );
    LoadingDialogue.hide();
    if (resp.resultStatus) {
      App.pushAndRemoveAll(
        (_) => const LoginScreen(),
        routeName: LoginScreen.routeName,
      );
    }

    resp.resultMessage.showToast;
  }

  @override
  void dispose() {
    currentPwCtrl.dispose();
    newPwCtrl.dispose();
    confirmPwCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardShortcut(
      onPressEscape: KeyboardShortcut.back,
      child: Scaffold(
        appBar: AppBar(title: const Text("Change Password")),
        backgroundColor: DesktopBodyWraperWid.backgroundColor,
        body: DesktopBodyWraperWid(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              spacing: 16,
              children: [
                TextFormField(
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.visiblePassword,
                  controller: currentPwCtrl,
                  style: const TextStyle(letterSpacing: 0.85),
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: "Fill your current password",
                    labelText: "Current Password*",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    counterText: "",
                  ),
                ),

                TextFormField(
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.visiblePassword,
                  controller: newPwCtrl,
                  obscureText: true,
                  style: const TextStyle(letterSpacing: 0.85),
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: "Fill your password",
                    labelText: "New Passowrd*",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    counterText: "",
                  ),
                ),

                TextFormField(
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.visiblePassword,
                  controller: confirmPwCtrl,
                  obscureText: true,
                  style: const TextStyle(letterSpacing: 0.85),
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: "Please confirm your password",
                    labelText: "Confirm Password*",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    counterText: "",
                  ),
                ),

                FilledButton(
                  onPressed: onUpdateClick,
                  child: const Text("Update"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
