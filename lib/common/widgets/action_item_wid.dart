import 'package:flutter/material.dart';

class ActionItemWid extends StatelessWidget {
  final Function()? onTap;
  final IconData? iconData;
  final Widget? icon;
  final String lable;
  final Color? color;
  const ActionItemWid({
    super.key,
    this.onTap,
    this.iconData,
    this.icon,
    required this.lable,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text.rich(
          TextSpan(
            children: [
              if (iconData != null)
                WidgetSpan(child: Icon(iconData, size: 22, color: color)),
              if (icon != null) WidgetSpan(child: icon!),
              if (lable.isNotEmpty)
                TextSpan(
                  text: "\n$lable",
                  style: TextStyle(fontSize: 10, color: color),
                ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
    // return InkWell(
    //   onTap: onTap,
    //   child: Container(
    //     padding: const EdgeInsets.symmetric(horizontal: 8),
    //     child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           2.heightBox,
    //           if (iconData != null)
    //             Icon(
    //               iconData,
    //               size: 22,
    //               color: color,
    //             ),
    //           if (icon != null) icon!,
    //           lable.textbody(
    //             size: 10,
    //             color: color,
    //           ),
    //         ]),
    //   ),
    // );
  }
}
