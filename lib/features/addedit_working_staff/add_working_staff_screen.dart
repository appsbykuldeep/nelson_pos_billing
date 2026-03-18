import 'package:flutter/material.dart';
import 'package:pos_billing/common/abstract_classes/stateful_util.dart';
import 'package:pos_billing/common/classes/socketio_handler.dart';
import 'package:pos_billing/common/dialogues/confirmation.dart';
import 'package:pos_billing/common/dialogues/show_loading.dart';
import 'package:pos_billing/common/models/item/item_info.dart';
import 'package:pos_billing/common/models/workstaff/workstaffmaster_model.dart';
import 'package:pos_billing/common/singletons/app.dart';
import 'package:pos_billing/common/singletons/login_ctrl.dart';
import 'package:pos_billing/common/widgets/action_item_wid.dart';
import 'package:pos_billing/common/widgets/custome_text_field.dart';
import 'package:pos_billing/common/widgets/cutom_radio_selection.dart';
import 'package:pos_billing/common/widgets/desktop_wraper_wid.dart';
import 'package:pos_billing/common/widgets/general_styled_text.dart';
import 'package:pos_billing/common/widgets/keyboard_shortcut.dart';
import 'package:pos_billing/config/constants/input_formatters.dart';
import 'package:pos_billing/config/constants/soket_events.dart';
import 'package:pos_billing/config/enums/current_status.dart';
import 'package:pos_billing/config/enums/user_roles.dart';
import 'package:pos_billing/core/extensions/string_ext.dart';
import 'package:pos_billing/core/extensions/textediting_ext.dart';
import 'package:pos_billing/core/functions/show_hide_keyboard.dart';

part 'add_working_staff_util.dart';

class WorkStaffPage extends StatefulWidget {
  final WorkingStaffMaster? staff;
  const WorkStaffPage({super.key, this.staff});

  static const String routeName = "/WorkStaffDetail";

  @override
  State<WorkStaffPage> createState() => _WorkStaffPageState();
}

// final _workStaff = FindCtrl.workStaff;

class _WorkStaffPageState extends State<WorkStaffPage> {
  late AddWorkingStaffUtil util;

  @override
  void initState() {
    util = AddWorkingStaffUtil(
      isEditmode: widget.staff != null && widget.staff!.userId > 0,
      selectedWorkStaff: widget.staff ?? WorkingStaffMaster(),
    );

    util.onPageInit();
    super.initState();
  }

  @override
  void dispose() {
    util.onPageClose();
    super.dispose();
  }

  TextStyle lableStyle = TextStyle(fontSize: 13, fontWeight: FontWeight.w500);

  @override
  Widget build(BuildContext context) {
    final wraperWidth = DesktopBodyWraperWid.getWidth(context);
    final theme = Theme.of(context);
    return KeyboardShortcut(
      onPressEscape: KeyboardShortcut.back,
      onPressCtrlS: util.createUpdateWorkStaff,
      child: Scaffold(
        appBar: AppBar(
          title: Text(util.isEditmode ? "Update Work Staff" : "New Work Staff"),
          actions: [
            if (util.isEditmode) ...[
              ActionItemWid(
                iconData: Icons.delete,
                lable: "Delete",
                onTap: util.deleteWorkStaff,
              ),
              ActionItemWid(
                iconData: Icons.lock_reset,
                lable: "Password",
                onTap: util.resetPassword,
              ),
            ],
          ],
        ),
        backgroundColor: DesktopBodyWraperWid.backgroundColor,
        body: DesktopBodyWraperWid(
          child: GestureDetector(
            onTap: util.onTapOutSide,
            child: SingleChildScrollView(
              padding: DesktopBodyWraperWid.isNotActive
                  ? const EdgeInsets.fromLTRB(10, 10, 8, 40)
                  : const EdgeInsets.fromLTRB(20, 20, 20, 120),
              child: Column(
                children: [
                  // CutomTextField(
                  //   isVisible: util.isEditmode,
                  //   enabled: false,
                  //   lable: "\u2022 Login Id*",
                  //   hint: "Fill login Id",
                  //   controller: util.loginIdCtrl,
                  // ),
                  CutomTextField(
                    lable: "\u2022 Full Name*",
                    hint: "Fill full name",
                    controller: util.nameCtrl,
                  ),

                  CutomTextField(
                    enabled: !util.isEditmode,
                    maxLength: 12,
                    lable: "\u2022 User Name*",
                    hint: "Create User Name",
                    controller: util.mobileCtrl,
                    textInputType: TextInputType.visiblePassword,
                    inputFormatters: userNameInputFormatters,

                    bottomWidget: const GeneralStyledText(
                      text:
                          "<b>Note:</b> <m>- @ _ . #</m> are alloed symbol for username.\n<b>Eg :</b> mobile number, raju458, harry-674 etc. It will use for login.",

                      textStyle: TextStyle(fontSize: 8),
                    ),
                  ),
                  CutomTextField(
                    isVisible: !util.isEditmode,
                    enabled: false,
                    lable: "\u2022 Default Password",
                    hint: "Fill password",
                    controller: util.pwCtrl,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "\u2022 Role",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      // child: "\u2022 Role".textbody(size: 13, weight: 5),
                    ),
                  ),

                  ValueListenableBuilder(
                    valueListenable: util.selectedUserRole,
                    builder: (context, selectedUserRole, child) {
                      return GridView.count(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(5, 16, 5, 0),
                        shrinkWrap: true,
                        crossAxisCount: (wraperWidth / 200).round(),
                        childAspectRatio: 3 / 1.2,
                        crossAxisSpacing: 10,
                        children: [
                          for (var x
                              in UserRole.workStaffRolesByCurrentUserRole(
                                util.user.role,
                              ))
                            Column(
                              key: ValueKey((x, "Column")),
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: ChargeTypeRadioSelection<UserRole>(
                                    label: x.lable,
                                    value: x,
                                    description: switch (x) {
                                      UserRole.staff =>
                                        "They can enter/exit vehicle, create pass & collect amount.",
                                      UserRole.admin => "As similer as owner*.",
                                      _ => "",
                                    },
                                    groupValue: selectedUserRole,
                                    onTap: util.onUserRoleChange,
                                    textStyle: const TextStyle(fontSize: 12),
                                  ),
                                ),
                                const Divider(),
                              ],
                            ),
                        ],
                      );
                    },
                  ),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "\u2022 Work staff Status ?",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  ValueListenableBuilder(
                    valueListenable: util.selectedStatus,
                    builder: (context, status, child) {
                      return Row(
                        children: [
                          for (var x in CurrentStatus.activeInactive)
                            Expanded(
                              child: _CustomRadioTile(
                                label: x.lable,
                                groupValue: status,
                                onTap: util.onChangeActiveStatus,
                                value: x,
                              ),
                            ),
                        ],
                      );
                    },
                  ),

                  AnimatedBuilder(
                    animation: Listenable.merge([
                      util.allowedVehicleCategoriesNotifier,
                      util.selectedUserRole,
                    ]),
                    builder: (context, child) {
                      final allowedVehicleCategories =
                          util.allowedVehicleCategoriesNotifier.value;
                      if (!util.selectedUserRole.value.isStaff ||
                          util.standVehicleCategories.isEmpty) {
                        return const SizedBox();
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 16,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "\u2022 Allowed Parking Categories ?",

                                style: lableStyle,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                            child: Column(
                              children: [
                                for (var e in util.standVehicleCategories)
                                  _VehicleCategoryInfo(
                                    e: e,
                                    isSelected: allowedVehicleCategories
                                        .contains(e.itemId),
                                    onTap: util.onChangedVehicalCategory,
                                  ),
                              ],
                            ),
                          ),
                          GeneralStyledText(
                            text:
                                "<m>Note : </m>\nIf no category selected. Then all category will be allowed !",

                            textStyle: theme.textTheme.bodySmall,
                          ),
                        ],
                      );
                    },
                  ),

                  SizedBox(height: 20),
                  SizedBox(
                    width: 150,
                    child: FilledButton(
                      onPressed: util.createUpdateWorkStaff,
                      child: Text(util.isEditmode ? "Update" : "Save"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CustomRadioTile<T> extends StatelessWidget {
  const _CustomRadioTile({
    required this.label,
    required this.groupValue,
    required this.onTap,
    required this.value,
  });
  final String label;
  final T groupValue;
  final ValueChanged<T> onTap;
  final T value;

  @override
  Widget build(BuildContext context) {
    final status = groupValue == value;
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => onTap.call(value),
      child: Text.rich(
        TextSpan(
          children: [
            WidgetSpan(
              child: Padding(
                padding: const EdgeInsets.only(right: 16, left: 10),
                child: Icon(
                  status
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  size: 20,
                  color: status ? theme.primaryColor : null,
                ),
              ),
              alignment: PlaceholderAlignment.middle,
            ),
            TextSpan(text: label, style: theme.textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}

class _VehicleCategoryInfo extends StatelessWidget {
  const _VehicleCategoryInfo({
    required this.e,
    required this.isSelected,

    required this.onTap,
  });

  final ItemInfo e;
  final bool isSelected;
  final void Function(bool isSelected, ItemInfo e) onTap;

  void onChangedCheckBox([bool? x]) {
    onTap(!isSelected, e);
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isSelected ? 1 : 0.5,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 5,
        children: [
          Expanded(
            flex: 3,
            child: InkWell(
              onTap: () => onChangedCheckBox(!isSelected),
              child: Text.rich(
                TextSpan(children: [TextSpan(text: e.itemName)]),
              ),
            ),
          ),

          Checkbox(value: isSelected, onChanged: onChangedCheckBox),
        ],
      ),
    );
  }
}
