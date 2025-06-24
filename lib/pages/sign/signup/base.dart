import 'dart:ui';
import 'package:flutter/material.dart';

class SignupAssistantBase extends StatelessWidget {
  final Widget title;
  final Widget body;
  final Function()? next;
  final bool showNextButton;
  final String nextText;

  const SignupAssistantBase({
    super.key,
    required this.title,
    required this.body,
    this.showNextButton = false,
    this.next,
    this.nextText = "Continue >",
  });

  // Define a breakpoint for wide screens
  static const double _wideScreenBreakpoint = 720.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: title,
        leading: const BackButton(),
        backgroundColor: Colors.transparent, // Make AppBar transparent
        elevation: 0, // No shadow for AppBar
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
        color: Theme.of(context).colorScheme.surface.withOpacity(0.85),
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
                body, // Your main form widgets
                if (showNextButton) ...[
                  const SizedBox(height: 24.0), // Spacing before the button
                  FilledButton(
                    onPressed: next,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      textStyle: Theme.of(context).textTheme.labelLarge,
                    ),
                    child: Text(nextText),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLeftPane(BuildContext context) {
    return SizedBox(
      height: 470,
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
                      "Welcome to IS",
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    const SizedBox(height: 30),
                    Text(
                      " Empowering connections, empowering futures ",
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
}
