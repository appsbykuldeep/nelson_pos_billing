import 'package:flutter/material.dart';

class SelectionTick extends StatelessWidget {
  const SelectionTick({super.key, this.checkRadius = 10});

  final double checkRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CircleAvatar(
      radius: checkRadius,
      backgroundColor: Colors.white,
      child: CircleAvatar(
        backgroundColor: theme.primaryColor,
        radius: checkRadius * (0.8),
        child: Icon(
          Icons.done,
          size: checkRadius * (0.7) * 2,
          color: Colors.white,
        ),
      ),
    );
  }
}
