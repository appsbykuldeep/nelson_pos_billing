import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pos_billing/core/extensions/string_ext.dart';
import 'package:pos_billing/core/functions/share_file.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../common/widgets/app_logo_wid.dart';

class ShareAppPage extends StatefulWidget {
  const ShareAppPage({super.key});

  static const String routeName = "/ShareAppPage";

  @override
  State<ShareAppPage> createState() => _ShareAppPageState();
}

class _ShareAppPageState extends State<ShareAppPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final qrsize = MediaQuery.sizeOf(context).width * 0.7;
    final appPlayStoreUrl = "";
    //AppLogoWid
    return Scaffold(
      appBar: AppBar(title: const Text("Share App"), elevation: 5),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 16,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: CustomPaint(
                      size: Size(qrsize, qrsize),
                      painter: QrPainter(
                        data: appPlayStoreUrl,
                        version: QrVersions.auto,
                        eyeStyle: QrEyeStyle(
                          eyeShape: QrEyeShape.circle,
                          color: theme.colorScheme.onSurface,
                        ),
                        dataModuleStyle: QrDataModuleStyle(
                          dataModuleShape: QrDataModuleShape.circle,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                ),
                AppLogoWid(borderWidth: 2, color: theme.primaryColor, size: 60),
              ],
            ),
            Text(
              "Scan QR Code.",
              style: theme.textTheme.labelMedium,
              textAlign: TextAlign.center,
            ),
            Row(
              spacing: 10,
              children: [
                Expanded(
                  child: _OptionCard(
                    iconData: Icons.copy,
                    lable: "Copy Link",
                    onTap: () async {
                      await Clipboard.setData(
                        ClipboardData(text: appPlayStoreUrl),
                      );
                      "Link copied to clipboard.".showToast;
                    },
                  ),
                ),

                Expanded(
                  child: _OptionCard(
                    iconData: Icons.share,
                    lable: "Share Link",
                    onTap: () {
                      shareMessage(appPlayStoreUrl);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  final IconData iconData;
  final String lable;
  final Function() onTap;
  const _OptionCard({
    required this.iconData,
    required this.lable,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Material(
        elevation: 3,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: theme.colorScheme.onPrimary, width: 0.75),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 10,
            children: [
              Icon(iconData, color: theme.primaryColor),

              Text(lable),
            ],
          ),
        ),
      ),
    );
  }
}
