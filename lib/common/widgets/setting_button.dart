import 'package:flutter/material.dart';
import 'package:pos_billing/common/singletons/app.dart';
import 'package:pos_billing/features/settings/settings_page.dart';

class SettingButton extends StatelessWidget {
  final VoidCallback onTap;

  const SettingButton({super.key, required this.onTap});

  static void gotoStandSettings() {
    App.to((_) => SettingsScreen(), routeName: SettingsScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Stack(
          children: [
            const Card(
              elevation: 0.35,
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Icon(Icons.settings, size: 25),
              ),
            ),
            // Positioned(
            //   top: 6,
            //   right: 6,
            //   child: AnimatedBuilder(
            //     animation: Listenable.merge([
            //       _localSync.isDBUpdatedNotifier,
            //       ShorebirdHandler.needRestart,
            //     ]),
            //     builder: (context, child) {
            //       final dbStatus =
            //           _localSync.isDBUpdatedNotifier.value.isupdated ||
            //           ShorebirdHandler.needRestart.value;
            //       if (!dbStatus) {
            //         return const RedDot();
            //       }
            //       return const SizedBox();
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
