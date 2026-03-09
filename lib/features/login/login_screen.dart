import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pos_billing/common/dialogues/login_confirmation.dart';
import 'package:pos_billing/common/dialogues/show_loading.dart';
import 'package:pos_billing/common/singletons/app.dart';
import 'package:pos_billing/common/singletons/device_package_info.dart';
import 'package:pos_billing/common/singletons/internet_connectivity.dart';
import 'package:pos_billing/common/singletons/login_ctrl.dart';
import 'package:pos_billing/config/constants/assets.dart';
import 'package:pos_billing/core/extensions/string_ext.dart';
import 'package:pos_billing/core/extensions/textediting_ext.dart';
import 'package:pos_billing/core/functions/app_update.dart';
import 'package:pos_billing/core/functions/show_hide_keyboard.dart';
import 'package:pos_billing/features/create_receipt/create_receipt_screen.dart';
import 'package:restart_app/restart_app.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String routeName = "/LoginPage";
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController useridCtrl = TextEditingController();
  TextEditingController userpwCtrl = TextEditingController();

  ValueNotifier<bool> showPassword = ValueNotifier(false);
  final _loginCtrl = LoginUtil.instance;

  void onPressEnter() {
    final id = useridCtrl.trimText;
    final pw = userpwCtrl.trimText;

    if (id.isNotEmpty && pw.isNotEmpty) {
      onTapLogin();
    }
  }

  void _setCredentials() {
    if (!kDebugMode) return;
    useridCtrl.text = "9616205455";
    userpwCtrl.text = "12345";
    // userpwCtrl.text = "Ge@856406";
  }

  void onLongPressLogin() async {
    if (!kDebugMode) {
      await Restart.restartApp();
    }
  }

  Future<void> onTapLogin({bool logoutPrevious = false}) async {
    final id = useridCtrl.trimText;
    final pw = userpwCtrl.trimText;
    if (id.isEmpty) {
      "Please fill userid.".showToast;
      return;
    }
    if (pw.isEmpty) {
      "Please fill password.".showToast;
      return;
    }

    if (InternetConnectivity.checkNotAvailableAndShowDialogue()) {
      return;
    }

    hideKeyboard();
    LoadingDialogue.show();
    final resp = await _loginCtrl.makeUserLogin(
      loginId: id,
      loginpw: pw.toMd5,
      logoutPrevious: logoutPrevious,
    );

    LoadingDialogue.hide();
    if (resp.resultStatus) {
      App.pushAndRemoveAll(
        (_) => const CreateReceiptScreen(),
        routeName: CreateReceiptScreen.routeName,
      );

      resp.resultMsj.showToast;
    } else if (resp.statusCode == 201 && !logoutPrevious) {
      final message = [resp.resultMsj].join("\n");
      final status = await LoginConfirmationDialogue.show(message);
      if (status) {
        onTapLogin(logoutPrevious: true);
      }
    } else {
      resp.resultMsj.showAlert;
    }
  }

  @override
  void initState() {
    _setCredentials();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      checkForUpdate();
    });
    super.initState();
  }

  @override
  void dispose() {
    useridCtrl.dispose();
    userpwCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 30),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 10,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: ValueListenableBuilder(
                  valueListenable: DevicePackageDetails.instance.details,
                  builder: (context, info, child) {
                    return Text.rich(
                      TextSpan(
                        text: "Version : ",
                        children: [
                          TextSpan(
                            text: info.version,
                            style: TextStyle(color: primaryColor),
                          ),
                        ],
                      ),
                      style: const TextStyle(fontSize: 11),
                    );
                  },
                ),
              ),

              SizedBox(height: 50),

              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 350),
                child: Column(
                  children: [
                    Hero(
                      tag: 'AppLogo',
                      child: Material(
                        color: Colors.transparent,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Image.asset(
                            Assets.imagesCounterToken,
                            height: 150,
                          ),
                        ),
                      ),
                    ),
                    Text("Billing POS", style: theme.textTheme.displaySmall),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 70),
                      child: Column(
                        spacing: 20,
                        children: [
                          TextFormField(
                            maxLength: 20,
                            maxLines: 1,
                            minLines: 1,
                            controller: useridCtrl,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.85,
                            ),
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                              isDense: true,
                              prefixIcon: const Icon(
                                Icons.account_circle_outlined,
                              ),
                              hintText: "Enter UserId or Regi. Mobile",
                              labelText: "UserId/Mobile",
                              counterText: "",
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              floatingLabelStyle: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: primaryColor,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),

                          ValueListenableBuilder(
                            valueListenable: showPassword,
                            builder: (context, obscureText, child) {
                              return TextFormField(
                                maxLength: 20,
                                maxLines: 1,
                                minLines: 1,
                                obscureText: !obscureText,
                                controller: userpwCtrl,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.85,
                                ),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.visiblePassword,
                                onFieldSubmitted: (value) {
                                  onPressEnter();
                                },
                                decoration: InputDecoration(
                                  isDense: true,
                                  prefixIcon: const Icon(Icons.security),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      showPassword.value = !showPassword.value;
                                    },
                                    child: Icon(
                                      obscureText
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: primaryColor,
                                    ),
                                  ),
                                  hintText: "Enter Password",
                                  labelText: "Password",
                                  counterText: "",
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  floatingLabelStyle: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: primaryColor,
                                      width: 1.5,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              );
                            },
                          ),

                          SizedBox(
                            width: 180,
                            child: FilledButton(
                              onPressed: onTapLogin,
                              onLongPress: onLongPressLogin,
                              child: Text("Login"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
