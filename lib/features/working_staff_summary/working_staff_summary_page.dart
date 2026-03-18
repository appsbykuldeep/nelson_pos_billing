import 'dart:async';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:pos_billing/common/abstract_classes/stateful_util.dart';
import 'package:pos_billing/common/classes/adaptive_image_provider.dart';
import 'package:pos_billing/common/classes/socketio_handler.dart';
import 'package:pos_billing/common/dialogues/show_loading.dart';
import 'package:pos_billing/common/models/workstaff/workstaff_info_model.dart';
import 'package:pos_billing/common/models/workstaff/workstaffmaster_model.dart';
import 'package:pos_billing/common/singletons/app.dart';
import 'package:pos_billing/common/singletons/internet_connectivity.dart';
import 'package:pos_billing/common/singletons/login_ctrl.dart';
import 'package:pos_billing/common/widgets/desktop_wraper_wid.dart';
import 'package:pos_billing/common/widgets/keyboard_shortcut.dart';
import 'package:pos_billing/common/widgets/no_recordfound_wid.dart';
import 'package:pos_billing/common/widgets/online_offline_indicator.dart';
import 'package:pos_billing/config/constants/assets.dart';
import 'package:pos_billing/config/constants/soket_events.dart';
import 'package:pos_billing/core/extensions/string_ext.dart';
import 'package:pos_billing/features/addedit_working_staff/add_working_staff_screen.dart';

part 'working_staff_summary_util.dart';

class WorkStaffSummaryScreen extends StatefulWidget {
  const WorkStaffSummaryScreen({super.key});

  static const String routeName = "/WorkStaffSummary";

  @override
  State<WorkStaffSummaryScreen> createState() => _WorkStaffSummaryScreenState();
}

class _WorkStaffSummaryScreenState extends State<WorkStaffSummaryScreen> {
  WorkingStaffSummaryUtil util = WorkingStaffSummaryUtil();

  @override
  void initState() {
    util.onPageInit();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.primaryColor;
    return KeyboardShortcut(
      onPressEscape: KeyboardShortcut.back,
      child: Scaffold(
        appBar: AppBar(elevation: 0, title: const Text("Work Staff")),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: util.onAddEditWorkStaff,
          label: const Text(
            "Work Staff",
            style: TextStyle(color: Colors.white),
          ),
          icon: const Icon(Icons.add, color: Colors.white),
        ),
        backgroundColor: DesktopBodyWraperWid.backgroundColor,
        body: DesktopBodyWraperWid(
          child: ValueListenableBuilder(
            valueListenable: util.showWorkStaffNotifier,
            builder: (context, showWorkStaff, child) {
              if (showWorkStaff == null) {
                return const SizedBox(
                  height: 2,
                  child: LinearProgressIndicator(),
                );
              }
              if (showWorkStaff.isEmpty) {
                return const NoRecordfound();
              }

              return GroupedListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 100),
                shrinkWrap: true,
                elements: showWorkStaff,
                groupBy: (e) => e.role,
                groupComparator: (a, b) =>
                    a.priorityLevel.compareTo(b.priorityLevel),

                // itemComparator: (a, b) {
                //   return a.userCode.compareTo(b.userCode);
                //   // final sort1 = a.userCode.compareTo(b.userCode);
                //   // final sort2 = a.activeStatus.compareTo(b.activeStatus);
                //   // if (sort1 != 0) {
                //   //   return sort1;
                //   // } else {
                //   //   return sort2;
                //   // }
                // },
                groupSeparatorBuilder: (e) => Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 0, 5),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        WidgetSpan(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: Icon(e.icon, size: 16, color: primary),
                          ),
                          alignment: PlaceholderAlignment.middle,
                        ),
                        TextSpan(text: e.lable),
                      ],
                    ),

                    style: theme.textTheme.labelMedium?.copyWith(
                      color: primary,
                    ),
                  ),
                ),
                itemBuilder: (context, e) =>
                    _WorkStaffCard(onedata: e, onTap: util.onAddEditWorkStaff),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _WorkStaffCard extends StatelessWidget {
  final WorkstaffInfoModel onedata;
  final ValueChanged<WorkingStaffMaster> onTap;

  const _WorkStaffCard({required this.onedata, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeStatus = onedata.currentStatus;
    final primaryColor = theme.primaryColor;

    final bool isActive = activeStatus.isActive;
    return InkWell(
      onTap: () => onTap.call(onedata),
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 4, 10, 8),
        decoration: BoxDecoration(
          // color: kdwhitecolor,
          border: Border(
            top: BorderSide(width: 0.35, color: theme.primaryColor),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: CircleAvatar(
                radius: 32,
                backgroundColor: isActive ? Colors.green : Colors.red,
                child: CircleAvatar(
                  backgroundImage: AdaptiveImageProvider(
                    onedata.profileImageBaseURLPath,
                    errorImage: Assets.imagesMalePerson,
                  ),
                  radius: 30,
                ),
              ),
            ),
            Expanded(
              child: Text.rich(
                TextSpan(
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  children: [
                    TextSpan(
                      children: [
                        TextSpan(
                          text: onedata.fullName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        WidgetSpan(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Icon(onedata.role.icon, size: 15),
                          ),
                          alignment: PlaceholderAlignment.middle,
                        ),
                        WidgetSpan(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: OnlineOfflineIndicator(
                              status: onedata.isOnline,
                            ),
                          ),
                          alignment: PlaceholderAlignment.middle,
                        ),
                        TextSpan(text: "\n${onedata.role.lable}"),
                        TextSpan(
                          text: " (${onedata.mobile})",
                          style: TextStyle(color: primaryColor),
                        ),
                        TextSpan(text: "\n${onedata.mobile}"),
                      ],
                    ),
                  ],
                ),
                textAlign: TextAlign.left,
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text.rich(
                TextSpan(
                  children: [
                    WidgetSpan(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 3),
                        child: Icon(
                          activeStatus.iconData,
                          color: activeStatus.color,
                          size: 32,
                        ),
                      ),
                    ),
                    TextSpan(
                      text: "\n${activeStatus.lable}",
                      style: const TextStyle(fontSize: 9),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
