import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:ins/analytics.dart' as analytics;
import '../../../backend/models.dart' as models;
import '../../../loadingpage.dart';
import './manager.dart';
import './base.dart';

class SubmitingFormPage extends AssistantBasePage {
  const SubmitingFormPage({
    super.key,
    super.title = "Submitting",
    required super.session,
    required super.user,
    required super.school,
    required super.assistantState,
    required super.form,
  });

  @override
  Widget buildContent(BuildContext context) {
    analytics.schoolApplySubmit(school.school_name);
    return _SubmitingFormView(
      assistantState: assistantState,
      session: session,
      formName: form.title,
    );
  }
}

class _SubmitingFormView extends StatefulWidget {
  final AssistantState assistantState;
  final models.Session session;
  final String formName;

  const _SubmitingFormView({
    required this.assistantState,
    required this.session,
    required this.formName,
  });

  @override
  State<_SubmitingFormView> createState() => _SubmitingFormViewState();
}

class _SubmitingFormViewState extends State<_SubmitingFormView> {
  late Future<void> _submitFuture;
  String? _error;

  @override
  void initState() {
    super.initState();
    _submitFuture = _submit();
  }

  Future<void> _submit() async {
    await Future.delayed(
      const Duration(seconds: 2),
    ); // Reduced delay for better UX
    try {
      await widget.assistantState.submit(widget.session);
    } catch (e) {
      setState(() {
        _error = _parseErrorMessage(e.toString(), context);
      });
    }
  }

  String _parseErrorMessage(String error, BuildContext context) {
    // Custom error message parsing can be added here
    if (error.contains('timeout')) {
      return AppLocalizations.of(
        context,
      )!.requestTimedOutPleaseCheckYourConnection;
    }
    if (error.contains('network')) {
      return AppLocalizations.of(
        context,
      )!.networkErrorPleaseCheckYourInternetConnection;
    }
    return AppLocalizations.of(context)!.submissionFailedPleaseTryAgain;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (_error != null) {
      return _buildErrorState(context, colorScheme);
    }

    return FutureBuilder<void>(
      future: _submitFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            _error == null) {
          return _buildSuccessState(context, colorScheme);
        }
        return _buildLoadingState(context);
      },
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return LoadingPage(
      messages: [
        AppLocalizations.of(context)!.submittingForm,
        AppLocalizations.of(context)!.almostThereProcessingYourInformation,
        AppLocalizations.of(context)!.finalizingYourSubmission,
      ],
    );
  }

  Widget _buildSuccessState(BuildContext context, ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              color: colorScheme.primary,
              size: 80,
            ),
            const SizedBox(height: 24),
            Text(
              AppLocalizations.of(context)!.submissionSuccessful,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(
                context,
              )!.yourFormHasBeenSubmittedSuccessfully,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(
                context,
              )!.youWillReceiveAConfirmationEmailShortly,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 32),
            FilledButton.tonal(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: Text(AppLocalizations.of(context)!.returnToDashboard),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: colorScheme.error, size: 80),
            const SizedBox(height: 24),
            Text(
              AppLocalizations.of(context)!.submissionFailed,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: colorScheme.error),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(
                context,
              )!.pleaseCheckYourInformationAndTryAgain,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton(
                  onPressed: () {
                    setState(() {
                      _error = null;
                      _submitFuture = _submit();
                    });
                  },
                  child: Text(AppLocalizations.of(context)!.tryAgain),
                ),
                const SizedBox(width: 16),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(AppLocalizations.of(context)!.goBack),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
