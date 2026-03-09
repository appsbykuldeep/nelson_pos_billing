import 'package:flutter/material.dart';
import 'package:pos_billing/common/abstract_classes/stateful_util.dart';
import 'package:pos_billing/common/classes/http_override.dart';
import 'package:pos_billing/common/data_source/local_source/local_db.dart';
import 'package:pos_billing/common/models/basic/permissions_model.dart';
import 'package:pos_billing/common/singletons/app.dart';
import 'package:pos_billing/common/singletons/bluetooth_connectivity.dart';
import 'package:pos_billing/common/singletons/device_package_info.dart';
import 'package:pos_billing/common/singletons/internet_connectivity.dart';
import 'package:pos_billing/common/singletons/login_ctrl.dart';
import 'package:pos_billing/common/singletons/pdf_helper.dart';
import 'package:pos_billing/config/constants/assets.dart';
import 'package:pos_billing/core/functions/app_orientation.dart';
import 'package:pos_billing/features/create_receipt/create_receipt_screen.dart';
import 'package:pos_billing/features/login/login_screen.dart';

part 'splash_util.dart';

class SplashScreen extends StatefulWidget {
  final String? externalDisplayUID;
  const SplashScreen({super.key, this.externalDisplayUID});

  static const String routeName = "/SplashScreen";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late SplashUtil util;

  @override
  void initState() {
    util = SplashUtil(
      externalDisplayUID: widget.externalDisplayUID,

      context: context,
    );
    util.onPageInit();
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
    return Scaffold(
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),

      body: Center(
        child: Hero(
          tag: 'AppLogo',
          child: Material(
            color: Colors.transparent,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Image.asset(Assets.imagesCounterToken, height: 150),
            ),
          ),
        ),
      ),
    );
  }
}
