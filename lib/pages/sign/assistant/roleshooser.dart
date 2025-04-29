import 'package:flutter/material.dart';
import 'package:ins/pages/sign/assistant/base.dart';
import 'package:ins/pages/sign/assistant/manager.dart';
import './namechooser.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RoleChooser extends StatelessWidget {
  final SignupAssistantState assistantState;

  const RoleChooser({super.key, required this.assistantState});

  void _next(BuildContext context, String choice) {
    assistantState.setRole(choice);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NameChooserPage(assistantState: assistantState),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AssistantBasePage(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Column(
            children: [
              Text(
                AppLocalizations.of(context)!.whatRoleBestFitsYou,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Spacer(),
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: FloatingActionButton.extended(
                      onPressed: () => _next(context, 'student'),
                      icon: Icon(Icons.school, size: 32),
                      label: Text(AppLocalizations.of(context)!.student, style: TextStyle(fontSize: 18)),
                      extendedPadding: EdgeInsets.symmetric(
                        horizontal: 42,
                        vertical: 16,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FloatingActionButton.extended(
                      onPressed: () => _next(context, 'instructor'),
                      icon: Icon(Icons.person, size: 32),
                      label: Text(AppLocalizations.of(context)!.instructor, style: TextStyle(fontSize: 18)),
                      extendedPadding: EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FloatingActionButton.extended(
                      onPressed: () => _next(context, 'administrator'),
                      icon: Icon(Icons.admin_panel_settings, size: 32),
                      label: Text(
                        AppLocalizations.of(context)!.administrator,
                        style: TextStyle(fontSize: 18),
                      ),
                      extendedPadding: EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FloatingActionButton.extended(
                      onPressed: () => _next(context, 'parent'),
                      icon: Icon(Icons.family_restroom, size: 32),
                      label: Text(AppLocalizations.of(context)!.parent, style: TextStyle(fontSize: 18)),
                      extendedPadding: EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      title: Text(AppLocalizations.of(context)!.role),
    );
  }
}
