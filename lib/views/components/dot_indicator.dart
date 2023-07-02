import 'package:flutter/material.dart';

class DotIndicator extends StatelessWidget {
  final bool isActive;
  const DotIndicator({
    super.key,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      decoration: BoxDecoration(
          color: isActive ? Colors.purple : Colors.grey,
          shape: BoxShape.circle),
      duration: const Duration(milliseconds: 300),
      height: isActive ? 10 : 5,
      width: isActive ? 10 : 5,
    );
  }
}
