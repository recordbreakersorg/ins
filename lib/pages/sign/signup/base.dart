import 'package:flutter/material.dart';

class SignupAssistantBase extends StatelessWidget {
  final Widget title;
  final Widget body;
  final Function()? next;
  final bool showNextButton;
  const SignupAssistantBase({
    super.key,
    required this.title,
    required this.body,
    this.showNextButton = false,
    this.next,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: title, leading: BackButton()),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              body,
              if (showNextButton) ...[
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: next,
                    child: const Text("Continue >"),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
