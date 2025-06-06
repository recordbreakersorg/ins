import 'dart:async';
import 'package:flutter/material.dart';
import './base.dart';
import './manager.dart';
import '../../../backend/models.dart';
import '../../dashboard/dashboard.dart';
import '../../../analytics.dart' as analytics;

class CreatingAccountPage extends StatefulWidget {
  final SignupAssistantState assistantState;

  const CreatingAccountPage({super.key, required this.assistantState});

  @override
  State<CreatingAccountPage> createState() => _CreatingAccountPageState();
}

class _CreatingAccountPageState extends State<CreatingAccountPage> {
  late final Future<User> _createAccountFuture;
  String _currentMessage = "...";
  Timer? _messageTimer;
  int _messageIndex = 0;

  final List<String> _messages = ["..."];

  @override
  void initState() {
    super.initState();
    _createAccountFuture = widget.assistantState.createAccount();
    _startMessageCycle();
  }

  void _startMessageCycle() {
    _messageTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _currentMessage = _messages[_messageIndex];
        _messageIndex = (_messageIndex + 1) % _messages.length;
      });
    });
  }

  @override
  void dispose() {
    _messageTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _messages.addAll([
      "Preparing your workspace...",
      "Configuring settings...",
      "Almost there...",
      "Just a few more moments...",
      "Creating your profile...",
      "Finalizing your account...",
      "Setting up your preferences...",
      "Loading your dashboard...",
    ]);
    return AssistantBasePage(
      title: Text("Creating your account"),
      body: FutureBuilder(
        future: _createAccountFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingContent();
          }

          if (snapshot.hasError) {
            return _buildErrorContent(snapshot.error);
          }
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showDashboard(snapshot.data as User);
          });
          return _buildSuccessContent();
        },
      ),
    );
  }

  Future<void> _showDashboard(User user) async {
    _messageTimer?.cancel();
    final session = await user.setNewSession(widget.assistantState.password!);
    analytics.signup(user.username, "manual");
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => DashboardPage(session: session, user: user),
      ),
      (route) => false,
    );
  }

  Widget _buildLoadingContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 24),
          Text(
            "Creating your account",
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            _currentMessage,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildErrorContent(Object? error) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 26),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 200, color: Colors.red),
            const SizedBox(height: 24),
            Text(
              "Account creation failed",
              style: Theme.of(
                context,
              ).textTheme.headlineLarge?.copyWith(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              '$error',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle, size: 200, color: Colors.green),
          const SizedBox(height: 24),
          Text(
            "Account created successfully!",
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            "Welcome to your new account!",
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
