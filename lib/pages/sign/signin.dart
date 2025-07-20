import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ins/appstate.dart';
import 'package:ins/l10n/app_localizations.dart';
import 'package:ins/l10n/app_localizations_en.dart';
import 'package:ins/utils/logger.dart';
import 'package:ins/widgets/locale_chooser.dart';
import 'package:ins/backend.dart' as backend;
import 'package:ins/models.dart' as models;
import 'package:ins/firebase_messaging.dart';

class SigninPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  SigninPage({super.key});

  // Define a breakpoint for wide screens
  static const double _wideScreenBreakpoint = 720.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.signin),
        leading: const BackButton(),
        backgroundColor: Colors.transparent, // Make AppBar transparent
        elevation: 0, // No shadow for AppBar
        actions: const [LocaleChooserWidget(), SizedBox(width: 30)],
      ),
      extendBodyBehindAppBar: true, // Allow body to extend behind AppBar
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsetsGeometry.all(100),
                child: Image.asset(
                  "assets/icon/is-transparent-crop.png", // Ensure this path is correct
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback if image fails to load
                    return Container(
                      color: Theme.of(context).colorScheme.secondary,
                    );
                  },
                ),
              ),
            ],
          ),

          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 15),
              child: Container(
                // Add a subtle tint to the blur for better text contrast if needed
                color: Colors.black.withOpacity(0.1),
              ),
            ),
          ),

          // 3. Content Layer
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final bool isWideScreen =
                    constraints.maxWidth > _wideScreenBreakpoint;

                if (isWideScreen) {
                  // Wide screen layout: Two-pane
                  return Row(
                    children: [
                      // Left pane (can be empty, show another graphic, or branding)
                      Expanded(flex: 1, child: _buildLeftPane(context)),
                      // Right pane (form content)
                      Expanded(
                        flex: 1, // Adjust flex
                        child: Center(
                          // Center the card in this pane
                          child: _buildFormContentCard(context),
                        ),
                      ),
                    ],
                  );
                } else {
                  // Narrow screen layout: Single centered column
                  return Center(child: _buildFormContentCard(context));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormContentCard(BuildContext context) {
    return Padding(
      // Add padding around the card itself for spacing from screen edges
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Material(
        elevation: 8.0,
        borderRadius: BorderRadius.circular(16.0),
        // Make card background slightly transparent to blend with blurred background
        color: Theme.of(context).colorScheme.surface.withAlpha(200),
        child: SingleChildScrollView(
          // Allows content to scroll if it's too long
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 400, // Max width for the form content itself
            ),
            child: Column(
              mainAxisSize:
                  MainAxisSize.min, // So column takes minimum necessary height
              crossAxisAlignment:
                  CrossAxisAlignment.stretch, // Button will stretch
              children: [
                _buildSigninForm(context),
                const SizedBox(height: 24.0), // Spacing before the button
                FilledButton(
                  onPressed: () => _signinUser(context),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 13.0),
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.signin,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLeftPane(BuildContext context) {
    return SizedBox(
      height: 400,
      width: 400,
      child: Card(
        margin: EdgeInsets.zero,
        shape: RoundedSuperellipseBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(5),
            bottomRight: Radius.circular(5),
          ),
        ),
        color: Theme.of(context).colorScheme.primaryContainer.withAlpha(200),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40, horizontal: 30),
          child: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.welcomeToIS,
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    const SizedBox(height: 30),
                    Text(
                      AppLocalizations.of(context)!.sloganShort,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSecondaryContainer.withAlpha(128),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSigninForm(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _usernameController,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.person_outline),
            labelText: AppLocalizations.of(context)!.username,
            hintText: 'temexvironie12',
            border: OutlineInputBorder(),
            helperText: AppLocalizations.of(context)!.usernameDesc,
          ),
          autofocus: true,
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.none,
          autocorrect: false,
          inputFormatters: [
            FilteringTextInputFormatter(
              " ",
              replacementString: "_",
              allow: false,
            ),
            FilteringTextInputFormatter.deny(RegExp(r'[^a-z0-9_]')),
          ],
        ),
        SizedBox(height: 20),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock_outlined),
            labelText: AppLocalizations.of(context)!.password,
            border: OutlineInputBorder(),
          ),
          obscureText: true,
        ),
      ],
    );
  }

  void _signinUser(BuildContext context) async {
    logger.i("Login in user");
    try {
      final result = await backend.query("v1/signin", {
        "username": _usernameController.text,
        "password": _passwordController.text,
      }, null);
      logger.i("received response: $result");
      if (result['status'] as int < 0) {
        throw Exception(result['message'] as String);
      }
      final session = models.Session.fromJson(
        result["session"] as Map<String, dynamic>,
      );
      final user = models.User.fromJson(result["user"] as Map<String, dynamic>);

      final state = await AppState.load();
      state.session = session;
      state.user = user;
      try {
        await state.save();
        await FirebaseMessagingHandler().requestPermissionAndRegisterToken();
      } catch (e) {
        if (context.mounted) {
          throw Exception(AppLocalizations.of(context)!.couldNotSaveAppState);
        } else {
          throw Exception(AppLocalizationsEn().couldNotSaveAppState);
        }
      }
    } catch (e) {
      logger.e(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          action: SnackBarAction(
            label: AppLocalizations.of(context)!.retry,
            onPressed: () {},
          ),
        ),
      );
      if (!context.mounted) return;
    }
  }
}
