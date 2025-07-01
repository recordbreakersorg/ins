import 'package:flutter/material.dart';
import 'switchingtext.dart';

class LoadingWidget extends StatelessWidget {
  final Duration switchInterval;
  final List<String> messages;
  const LoadingWidget({
    super.key,
    this.messages = const ["..."],
    this.switchInterval = const Duration(seconds: 5),
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          SwitchingText(
            texts: messages,
            interval: switchInterval,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
