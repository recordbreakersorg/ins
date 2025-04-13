import 'dart:async';

import 'package:flutter/material.dart';
import './base.dart';
import './manager.dart';

class CreatingAccountPage extends StatefulWidget {
  final SignupAssistantState assistantState;
  @override
  State<CreatingAccountPage> createState() => _CreatingAccountPageState();
  const CreatingAccountPage({super.key, required this.assistantState});
  void onAccountCreated(BuildContext context) {
    // Handle account creation success
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (context) => AssistantBasePage(
              body: Center(child: Text('Account created successfully!')),
              title: Text("Success"),
            ),
      ),
    );
  }

  void onAccountCreationFailed(BuildContext context) {
    // Handle account creation failure
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to create account. Please try again.')),
    );
  }
}

class _CreatingAccountPageState extends State<CreatingAccountPage> {
  String _currentMessage = 'Setting up your new account...';

  @override
  void initState() {
    super.initState();
    _startMessageCycle();
  }

  void _startMessageCycle() {
    int messageIndex = 0;
    final messages = [
      'Preparing your workspace...',
      'Configuring settings...',
      'Almost there...',
      'Just a few more moments...',
      'Creating your profile...',
      'Finalizing your account...',
      'Setting up your preferences...',
      'Loading your dashboard...',
    ];

    Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        _currentMessage = messages[messageIndex];
        messageIndex = (messageIndex + 1) % messages.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AssistantBasePage(
      title: Text("Creating you account"),
      body: FutureBuilder(
        future: widget.assistantState.createAccount(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            widget.onAccountCreationFailed(context);
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            );
          }
          if (!snapshot.hasData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 24),
                  Text(
                    'Creating your account...',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _currentMessage,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle, size: 64, color: Colors.green),
                const SizedBox(height: 24),
                Text(
                  'Account created successfully!',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Welcome to your new account!',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
