import 'package:flutter/material.dart';

class OnlineOfflineIndicator extends StatelessWidget {
  final bool status;
  final double radius;
  const OnlineOfflineIndicator({
    super.key,
    required this.status,
    this.radius = 4,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 4,
      backgroundColor: status ? Colors.green.shade800 : Colors.red.shade800,
    );
  }
}
