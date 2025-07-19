import 'package:flutter/material.dart';
import 'package:ins/l10n/app_localizations.dart';
import 'package:ins/pages/sign/signin.dart';
import 'package:ins/pages/sign/signup/launcher.dart';
import 'package:ins/widgets/locale_chooser.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;

    final double avatarRadius = (screenWidth * 0.22).clamp(70.0, 110.0);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.welcomeExcl),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: const [LocaleChooserWidget(), SizedBox(width: 20)],
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Center children horizontally
              children: [
                const Spacer(flex: 2), // Pushes content down from AppBar

                CircleAvatar(
                  // Ensure this asset path is correct and declared in pubspec.yaml
                  backgroundImage: const AssetImage('assets/icon/is.png'),
                  radius: avatarRadius,
                  backgroundColor: colorScheme
                      .secondaryContainer, // Fallback bg if image is transparent/fails
                ),

                const SizedBox(height: 32.0),

                Text(
                  AppLocalizations.of(context)!.welcomeToIS,
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 12.0),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    AppLocalizations.of(context)!.welcomeConnectOrCreateAccount,
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const Spacer(flex: 3),

                _buildWelcomeButton(
                  context: context,
                  text: AppLocalizations.of(context)!.connectAccount,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SigninPage()),
                    );
                  },
                  isPrimary: false,
                ),

                const SizedBox(height: 16.0),

                _buildWelcomeButton(
                  context: context,
                  text: AppLocalizations.of(context)!.createAccount,
                  onPressed: () {
                    launchSignupAssistant(context);
                  },
                  isPrimary: true,
                ),

                const Spacer(flex: 1), // Adds some breathing room at the bottom
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeButton({
    required BuildContext context,
    required String text,
    required VoidCallback onPressed,
    bool isPrimary = false,
  }) {
    // Common styling for buttons
    final baseStyle = ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
      textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.w600, // Slightly bolder
        fontSize: 16, // Slightly larger font
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0), // More rounded, modern feel
      ),
      minimumSize: Size(MediaQuery.of(context).size.width * 0.6, 52),
    );

    if (isPrimary) {
      return FilledButton(
        onPressed: onPressed,
        style: baseStyle,
        child: Text(text),
      );
    } else {
      return FilledButton.tonal(
        onPressed: onPressed,
        style: baseStyle,
        child: Text(text),
      );
    }
  }
}
