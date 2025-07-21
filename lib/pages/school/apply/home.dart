import 'package:flutter/material.dart';
import 'package:ins/appstate.dart';
import 'package:ins/l10n/app_localizations.dart';
import 'package:ins/models.dart' as models;
import 'package:ins/widgets/imsg.dart';

class SchoolApplyHomePage extends StatelessWidget {
  final AppState appState;
  final models.School school;

  const SchoolApplyHomePage({
    super.key,
    required this.school,
    required this.appState,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.schoolApplication),
      ),
      body: FutureBuilder<List<models.SchoolApplicationForm>>(
        future: school.getApplicationForms(appState.session),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return Center(
                child: Text(AppLocalizations.of(context)!.nothingHere),
              );
            }
            return _buildPage(context, snapshot.data!);
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return IMsgWidget(
              icon: const Icon(Icons.error, size: 200, color: Colors.red),
              message: Text(
                "${AppLocalizations.of(context)!.couldNotGetSchoolApplicationForms}: ${snapshot.error}",
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Colors.red),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildPage(
    BuildContext context,
    List<models.SchoolApplicationForm> forms,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
          child: Text(
            AppLocalizations.of(context)!.whatDoYouWantToApplyFor,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 8.0),
            itemCount: forms.length,
            itemBuilder: (BuildContext context, int index) {
              final form = forms[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () {
                    // TODO: Handle form selection and navigation
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          form.title,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 10),
                        if (form.description != null &&
                            form.description!.isNotEmpty)
                          Text(
                            form.description!,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium,
                          )
                        else
                          Text(
                            AppLocalizations.of(context)!.noDescriptionProvided,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey,
                                ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
