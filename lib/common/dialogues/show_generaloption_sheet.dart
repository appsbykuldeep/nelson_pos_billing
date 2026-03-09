import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pos_billing/common/singletons/app.dart';
import 'package:pos_billing/config/enums/app_general_options.dart';
import 'package:pos_billing/core/extensions/app_context_ext.dart';
import 'package:vector_graphics/vector_graphics.dart';

Future<AppGeneralOption> showGeneralOptionSheet({
  String? title,
  required BuildContext context,
  // bool showView = false,
  // bool showPaymentQR = false,
  // bool showValetView = false,
  required List<AppGeneralOption> options,
}) async {
  // List<Widget> children = [
  //   const _Action(actionchild: null, option: TicketPassOption.print),
  //   const _Action(actionchild: null, option: TicketPassOption.whatsApp),
  //   if (showPaymentQR)
  //     const _Action(actionchild: null, option: TicketPassOption.paymentQR),
  //   if (showView)
  //     const _Action(actionchild: null, option: TicketPassOption.view),
  //   if (showValetView)
  //     const _Action(actionchild: null, option: TicketPassOption.valetView),
  // ];

  if (options.isEmpty) {
    return AppGeneralOption.none;
  }

  if (options.length == 1) {
    return options[0];
  }
  int crossAxisCount = 4;
  double childAspectRatio = 1;
  if (App.isNotMobileDevice) {
    crossAxisCount = (context.sizeOf.width / 200).round();
  }
  final theme = Theme.of(context);
  List<Widget> children = options
      .map(
        (e) => _Action(
          actionchild: null,
          option: e,
          primaryColor: theme.primaryColor,
        ),
      )
      .toList();

  final status = await showModalBottomSheet<AppGeneralOption>(
    context: context,
    barrierColor: Colors.black38,
    useSafeArea: true,
    builder: (context) {
      return Material(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 16, 0, 0),
              child: Text(
                "\u2022 ${title ?? "Choose an option !"}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: theme.primaryColor,
                ),
              ),
            ),
            GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: crossAxisCount,
              padding: EdgeInsets.fromLTRB(
                10,
                16,
                10,
                20 + context.viewPaddingOf.bottom,
              ),
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
              childAspectRatio: childAspectRatio,
              children: children,
            ),
          ],
        ),
      );
    },
  );

  return status ?? AppGeneralOption.none;
}

// class _Div extends StatelessWidget {
//   const _Div();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 0.5,
//       height: 35,
//       color: Colors.black,
//     );
//   }
// }

class _Action extends StatelessWidget {
  final Widget? actionchild;
  final AppGeneralOption option;
  final Color primaryColor;
  const _Action({
    required this.actionchild,
    required this.option,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context, option);
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
          child: Center(
            child: Text.rich(
              TextSpan(
                children: [
                  if (actionchild != null)
                    WidgetSpan(
                      child: actionchild!,
                      alignment: PlaceholderAlignment.middle,
                    ),
                  if (actionchild == null)
                    WidgetSpan(
                      child: option.svgPath.isNotEmpty
                          ? SvgPicture(
                              AssetBytesLoader(option.svgPath),
                              height: 30,
                            )
                          : Icon(
                              option.iconData,
                              color: primaryColor,
                              size: 30,
                            ),
                      alignment: PlaceholderAlignment.middle,
                    ),
                  TextSpan(
                    text: "\n${option.label}",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: context.onSurface,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
