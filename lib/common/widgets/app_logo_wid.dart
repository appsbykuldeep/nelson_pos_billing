import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pos_billing/common/singletons/app.dart';
import 'package:pos_billing/config/constants/const_colors.dart';
import 'package:vector_graphics/vector_graphics.dart';

class AppLogoWid extends StatelessWidget {
  final double size;
  final Color? color;
  final double? borderWidth;
  final double padding;
  const AppLogoWid({
    super.key,
    this.size = 100,
    this.color,
    this.borderWidth,
    this.padding = 8,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final double x =
        borderWidth ??
        switch (size) {
          <= 100 => 1,
          > 100 && <= 200 => 1.5,
          _ => 2,
        };

    if (1 == 0) {
      return Padding(
        padding: EdgeInsets.all(padding),
        child: SvgPicture(
          AssetBytesLoader(App.company.svglogoPath),
          height: size + 30,
          fit: BoxFit.contain,
        ),
      );
    }

    if (App.company.isParkingTicket) {
      return DecoratedBox(
        decoration: const BoxDecoration(shape: BoxShape.circle, color: kGreen),
        child: Padding(
          padding: EdgeInsets.all(x),
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.scaffoldBackgroundColor,
            ),
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: SvgPicture(
                AssetBytesLoader(App.company.svglogoPath),
                height: size,
                colorFilter: ColorFilter.mode(
                  color ?? theme.primaryColor,
                  BlendMode.srcIn,
                ),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      );
    }

    return const SizedBox();
  }
}
