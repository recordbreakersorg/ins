import 'package:flutter/material.dart';

class IMsgWidget extends StatelessWidget {
  final Icon icon;
  final Text message;
  final Widget? actions;
  final bool spacer;
  const IMsgWidget({
    super.key,
    required this.icon,
    required this.message,
    this.actions = const SizedBox.shrink(),
    this.spacer = true,
  });
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsetsGeometry.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        child: Column(
          children: [
            SizedBox(height: 10),
            icon,
            SizedBox(height: 20),
            message,
            if (spacer) Spacer(),
            if (actions != null)
              SizedBox(width: double.infinity, child: actions!),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
