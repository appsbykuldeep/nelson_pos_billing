import 'package:flutter/material.dart';
import 'package:pos_billing/common/classes/adaptive_image_provider.dart';
import 'package:pos_billing/common/data_source/cache/salereceipt_info_cache_data.dart';
import 'package:pos_billing/common/singletons/app.dart';
import 'package:pos_billing/common/singletons/device_package_info.dart';
import 'package:pos_billing/common/widgets/app_title_wid.dart';
import 'package:pos_billing/common/widgets/desktop_wraper_wid.dart';
import 'package:pos_billing/common/widgets/keyboard_shortcut.dart';
import 'package:pos_billing/common/widgets/online_offline_indicator.dart';
import 'package:pos_billing/config/constants/assets.dart';
import 'package:pos_billing/core/extensions/app_context_ext.dart';
import 'package:pos_billing/core/extensions/string_ext.dart';
import 'package:pos_billing/features/settings/settings_utils.dart';

class SettingsScreen extends StatefulWidget {
  final bool isSideBar;
  const SettingsScreen({super.key, this.isSideBar = false});

  static const String routeName = "/Settings";

  static const double minWidth = 300;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late SettingsUtils util;

  late final bool isWebView = widget.isSideBar;

  @override
  void initState() {
    util = SettingsUtils(context: context);
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
    final body = StandSettingsBody(
      util: util,
      isWebView: isWebView,
      isSideBar: widget.isSideBar,
    );

    if (isWebView) {
      return Material(
        elevation: 0,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: body,
      );
    }

    return KeyboardShortcut(
      focusNode: util.screenFocus,
      onPressEscape: KeyboardShortcut.back,
      child: Scaffold(
        appBar: widget.isSideBar
            ? null
            : AppBar(
                titleSpacing: 5,
                centerTitle: false,
                title: const AppTitleText("Settings"),
              ),
        backgroundColor: DesktopBodyWraperWid.backgroundColor,
        body: DesktopBodyWraperWid(child: body),
      ),
    );
  }
}

class StandSettingsBody extends StatelessWidget {
  const StandSettingsBody({
    super.key,

    required this.util,
    required this.isWebView,
    required this.isSideBar,
  });

  final SettingsUtils util;
  final bool isWebView;
  final bool isSideBar;

  @override
  Widget build(BuildContext context) {
    final deviceType = context.deviceType;
    final theme = Theme.of(context);
    final primary = theme.primaryColor;

    return SingleChildScrollView(
      padding: deviceType.isMobile
          ? const EdgeInsets.fromLTRB(10, 0, 10, 40)
          : isSideBar
          ? const EdgeInsets.fromLTRB(10, 40, 10, 40)
          : const EdgeInsets.fromLTRB(30, 0, 30, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Container(
              // color: Colors.black12,
              padding: const EdgeInsets.all(8.0),
              // decoration: BoxDecoration(
              //   border: Border(
              //     bottom: BorderSide(
              //       width: 0.35,
              //       color: context.primaryColor,
              //     ),
              //   ),
              // ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ValueListenableBuilder(
                          valueListenable: util.login.userNotifier,
                          builder: (context, user, child) {
                            return Text.rich(
                              TextSpan(
                                text: user.userFullName,
                                children: [
                                  WidgetSpan(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 6),
                                      child: ValueListenableBuilder(
                                        valueListenable: util.isSocketConnected,
                                        builder: (context, value, child) {
                                          return OnlineOfflineIndicator(
                                            status: value,
                                          );
                                        },
                                      ),
                                    ),
                                    alignment: PlaceholderAlignment.middle,
                                  ),
                                  TextSpan(
                                    text:
                                        "\n${user.role.lable} (${user.userMobile})",
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: context.primaryColor,
                                // fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: util.onTapProfileImage,
                          child: CircleAvatar(
                            radius: 31,
                            backgroundColor: context.primaryColor,
                            child: ValueListenableBuilder(
                              valueListenable: util.profileImage,
                              builder: (context, path, child) {
                                return CircleAvatar(
                                  radius: 30,
                                  backgroundImage: AdaptiveImageProvider(
                                    path.onNullOrEmpty("profileImage"),
                                    errorImage: Assets.imagesMalePerson,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        // const Icon(
                        //   Icons.account_circle,
                        //   size: 45,
                        //   color: Colors.black38,
                        // ),
                        Text(
                          DevicePackageDetails.instance.details.value.version,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 10, 10, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OptionCategory(
                  lable: "Account Information",
                  children: [
                    if (1 == 0)
                      OptionTile(
                        title: "Update Profile",
                        iconData: Icons.account_circle,
                      ),
                    OptionTile(
                      title: "Change Password",
                      iconData: Icons.password,
                      onTap: util.onTapChangePassword,
                    ),
                  ],
                ),
                if (util.userRole.isOwnerOrAdmin)
                  OptionCategory(
                    lable: "General",
                    children: [
                      OptionTile(
                        title: "Work Staff",
                        iconData: Icons.badge,
                        onTap: util.onTapWorkStaffs,
                      ),
                      OptionTile(
                        title: "Items",
                        iconData: Icons.category,
                        onTap: util.onTapItemHistory,
                      ),
                    ],
                  ),
                OptionCategory(
                  lable: "Reports",
                  children: [
                    OptionTile(
                      title: "User Wise Daily Sale",
                      iconData: Icons.currency_rupee,
                      onTap: util.onTapUserWiseDailySaleReport,
                    ),
                    OptionTile(
                      title: "Item Wise Daily Sale",
                      iconData: Icons.currency_rupee,
                      onTap: util.onTapItemWiseDailySaleReport,
                    ),
                    OptionTile(
                      title: "Sale History",
                      iconData: Icons.history,
                      onTap: util.onTapSaleHistoryReport,
                    ),
                  ],
                ),

                OptionCategory(
                  lable: "Printers",
                  children: [
                    OptionTile(
                      title: "Connect Printer",
                      iconData: Icons.print,
                      onTap: util.onTapConnectPrinter,
                    ),
                    OptionTile(
                      title: "Test Print",
                      iconData: Icons.confirmation_number,
                      onTap: util.onTapTestPrint,
                    ),
                  ],
                ),

                OptionCategory(
                  lable: "Other",
                  initiallyExpanded: true,
                  children: [
                    if (1 == 0)
                      OptionTile(
                        title: "Share App",
                        iconData: Icons.share,
                        onTap: util.onTapShareApp,
                        // onTap: BasicNavigations.onTapShareApp,
                      ),

                    ValueListenableBuilder(
                      valueListenable:
                          SalereceiptInfoCacheData.instance.isDBUpdatedNotifier,
                      builder: (context, status, _) {
                        return GestureDetector(
                          child: OptionTile(
                            title: "Cloud sync",
                            iconData: Icons.cloud_sync_sharp,
                            onTap:
                                SalereceiptInfoCacheData.instance.syncLocalData,
                            tralling: Icon(
                              status.iconData,
                              // size: 18,
                              color: status.color ?? context.primaryColor,
                            ),
                          ),
                        );
                      },
                    ),
                    OptionTile(
                      title: "Restart App",
                      iconData: Icons.restart_alt,
                      onTap: util.restartApp,
                    ),

                    if (!App.isDesktopDevice)
                      OptionTile(
                        title: "Log Out",
                        iconData: Icons.logout,
                        showTralling: false,
                        onTap: util.onTapLogOut,
                      ),
                  ],
                ),

                if (App.isDesktopDevice)
                  OptionTile(
                    title: "Log Out",
                    iconData: Icons.logout,
                    showTralling: false,
                    onTap: util.onTapLogOut,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OptionCategory extends StatelessWidget {
  final String lable;
  final List<Widget> children;
  final bool initiallyExpanded;
  const OptionCategory({
    super.key,
    required this.lable,
    required this.children,
    this.initiallyExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) {
      return const SizedBox();
    }
    final theme = Theme.of(context);

    if (App.isDesktopDevice) {
      return ExpansionTile(
        // initiallyExpanded: initiallyExpanded,
        iconColor: theme.primaryColor,
        childrenPadding: const EdgeInsets.all(10),
        // showTrailingIcon: !initiallyExpanded,
        shape: const RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.zero,
        ),
        collapsedShape: const RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.zero,
        ),
        tilePadding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
        backgroundColor: theme.primaryColor.withAlpha(20),
        collapsedIconColor: theme.primaryColor,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            lable,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        children: children,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            lable,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.blueGrey.shade400,
            ),
          ),
        ),
        ...children,
      ],
    );
  }
}

class OptionTile extends StatelessWidget {
  final String title;
  final String subTitle;
  final IconData? iconData;
  final bool showTralling;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Widget? leading;
  final Widget? tralling;
  const OptionTile({
    super.key,
    required this.title,
    this.subTitle = '',
    this.iconData,
    this.showTralling = true,
    this.leading,
    this.tralling,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      splashColor: Colors.transparent,
      overlayColor: WidgetStateProperty.resolveWith((_) => Colors.transparent),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            CircleAvatar(
              radius: 15,
              backgroundColor: context.primaryColor.withOpacity(0.15),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child:
                    leading ??
                    Icon(iconData, color: context.primaryColor, size: 18),
              ),
            ),
            SizedBox(width: 16),
            Expanded(child: Text(title, style: theme.textTheme.bodyMedium)),
            if (showTralling)
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child:
                    tralling ??
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: context.primaryColor,
                    ),
              ),
          ],
        ),
      ),
    );
  }
}
