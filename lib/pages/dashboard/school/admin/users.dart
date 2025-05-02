import 'package:flutter/material.dart';
import 'package:ins/profile.dart';
import './base.dart';
import 'package:ins/loadingpage.dart';
import 'package:ins/errorpage.dart';
import 'package:ins/backend/models.dart' as models;
import './application_form_review.dart';

class AdminSchoolUsersPage extends AdminSchoolViewBase {
  const AdminSchoolUsersPage({
    super.key,
    super.index = 1,
    required super.school,
    required super.member,
    required super.session,
    required super.user,
  });

  @override
  String getTitle(BuildContext context) {
    return "School Members";
  }

  @override
  Widget buildContent(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              "Current members",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Card.outlined(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(10),
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    FutureBuilder(
                      future: school.getMembers(session),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return LoadingPage(
                            messages: [
                              "Getting all school members...",
                              "Crunching database records...",
                              "Please wait...",
                            ],
                          );
                        } else if (snapshot.hasError) {
                          return ErrorPage(
                            title: "Error getting members",
                            description: snapshot.error.toString(),
                          );
                        } else if (snapshot.hasData) {
                          final members = snapshot.data!;
                          return ListView.builder(
                            itemCount: members.length,

                            itemBuilder: (context, index) {
                              final member = members[index];
                              final side = 50;
                              return FutureBuilder<models.User>(
                                future: member.getUser(session),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return const Icon(Icons.error);
                                  } else if (snapshot.hasData) {
                                    return ListTile(
                                      title: Text(snapshot.data!.info.name),
                                      leading: profileAvatar(
                                        radius: side.toDouble(),
                                        profile: snapshot.data?.profile,
                                        name: snapshot.data?.info.name,
                                      ),
                                      subtitle: Text(member.role.toJson()),
                                      onTap: () {
                                        // Handle member tap
                                      },
                                    );
                                  } else {
                                    return const Icon(Icons.error);
                                  }
                                },
                              );
                            },
                            shrinkWrap: true,
                          );
                        } else {
                          return Text("No members found");
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text("Pending Applications"),
            Card.outlined(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(10),
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    FutureBuilder<List<models.SchoolApplicationFormAttempt>>(
                      future: school.getApplicationAttempts(session),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return LoadingPage(
                            messages: [
                              "Getting all school applications...",
                              "Please wait...",
                            ],
                          );
                        } else if (snapshot.hasError) {
                          return ErrorPage(
                            title: "Error getting applications attempts",
                            description: snapshot.error.toString(),
                          );
                        } else if (snapshot.hasData) {
                          final applications = snapshot.data ?? [];
                          applications.removeWhere(
                            (application) => application.reviewed,
                          );

                          return applications.isNotEmpty
                              ? ListView.builder(
                                itemCount: applications.length,

                                itemBuilder: (context, index) {
                                  final application = applications[index];
                                  final side = 50;
                                  return FutureBuilder<
                                    models.AttempteeNApplicationForm
                                  >(
                                    future: application
                                        .getAttempteeNApplicationForm(session),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        return Column(
                                          children: [
                                            Icon(Icons.error),
                                            Text(snapshot.error.toString()),
                                          ],
                                        );
                                      } else if (snapshot.hasData) {
                                        final anaf = snapshot.data!;
                                        return ListTile(
                                          title: Text(
                                            anaf.applicationForm.title,
                                          ),
                                          leading: profileAvatar(
                                            radius: side.toDouble(),
                                            profile: anaf.attemptee.profile,
                                            name: anaf.attemptee.info.name,
                                          ),
                                          subtitle: Text(
                                            anaf.attemptee.username,
                                          ),
                                          onTap: () async {
                                            // Fetch the full form for the attempt
                                            final form = await application
                                                .getApplicationForm(session);
                                            if (!context.mounted) return;
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (context) =>
                                                        ApplicationFormReviewPage(
                                                          attempt: application,
                                                          form: form,
                                                          session: session,
                                                          member: member,
                                                          user: user,
                                                          school: school,
                                                        ),
                                              ),
                                            );
                                          },
                                        );
                                      } else {
                                        return Column(
                                          children: [
                                            Icon(Icons.error),
                                            Text('Unknown error'),
                                          ],
                                        );
                                      }
                                    },
                                  );
                                },
                                shrinkWrap: true,
                              )
                              : Center(
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.person_off_rounded,
                                      color: Colors.grey,
                                    ),
                                    Text(
                                      "No pending application.",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              );
                        } else {
                          return Text("No members found");
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
