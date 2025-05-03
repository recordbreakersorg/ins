import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'feeds.dart';
import 'base.dart';
import 'package:ins/backend/models.dart' as models;
import 'package:ins/loadingpage.dart';
import 'package:ins/errorpage.dart';
import 'school/home.dart';

class DashboardPage extends DashboardBase {
  const DashboardPage({
    super.key,
    super.navIndex = 0,
    super.title = "Dashboard",
    required super.session,
    required super.user,
  });
  /*Widget _buildSchoolShortcuts(BuildContext context) {
    return FutureBuilder<List<models.School>>(
      future: user.getSchools(session),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Container();
        } else if (!snapshot.hasData) {
          return CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
          );
        } else if (snapshot.data!.isEmpty) {
          return Container();
        } else {
          final schools = snapshot.data!;
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:
                  schools
                      .map(
                        (school) => SchoolThumbnailCard(
                          school: school,
                          onTap: () {
                            launchSchoolDashboard(
                              context,
                              school,
                              user,
                              session,
                            );
                          },
                        ),
                      )
                      .toList(),
            ),
          );
        }
      },
    );
  }*/

  @override
  Widget buildContent(BuildContext context) {
    return FutureBuilder(
      future: user.getFeeds(session),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingPage(
            messages: [
              "Loading your feeds...",
              "Please wait...",
              "Cross your fingers",
            ],
          );
        } else if (snapshot.hasError) {
          return ErrorPage(
            title: "Error loading your feeds",
            description: snapshot.error.toString(),
            icon: Icon(
              Icons.signal_wifi_off,
              color: Theme.of(context).colorScheme.error,
              size: 200,
            ),
          );
        } else {
          final feeds = snapshot.data ?? [];
          feeds.removeWhere((feed) => feed.dismissed);

          return FeedsView(feeds: feeds, session: session);
        }
      },
    );
  }
}

class FeedsView extends StatefulWidget {
  final List<models.UserFeed> feeds;
  final models.Session session;
  const FeedsView({super.key, required this.feeds, required this.session});
  @override
  State<FeedsView> createState() => _FeedsViewState();
}

class _FeedsViewState extends State<FeedsView> {
  List<models.UserFeed> feeds = [];
  @override
  void initState() {
    super.initState();
    feeds = widget.feeds;
  }

  @override
  Widget build(BuildContext context) {
    if (feeds.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 200,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),

            Text(
              "All caught up!",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: feeds.length,
      itemBuilder: (context, index) {
        final feed = feeds[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: NotificationFeedView(
            feed: feed,
            dismiss: (feed) async {
              setState(() {
                feeds.remove(feed);
              });
              feed.dismiss(widget.session);
            },
          ),
        );
      },
    );
  }
}

class SchoolThumbnailCard extends StatelessWidget {
  final models.School school;
  final void Function() onTap;

  const SchoolThumbnailCard({
    super.key,
    required this.school,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Hero(
                tag: school.profile.getPath(),
                transitionOnUserGestures: true,
                child: Container(
                  width: 150, // Increased width
                  height: 150, // Increased height
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(school.profile.getPath()),
                      fit:
                          BoxFit
                              .cover, // Ensure image covers the entire container
                    ),
                    color: Colors.transparent,
                    backgroundBlendMode: BlendMode.srcOver,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        color: Colors.transparent,
                        child: Center(
                          child: FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image: school.profile.getPath(),
                            width: 70, // Increased width
                            height: 70, // increased height
                            fit: BoxFit.cover,
                            imageErrorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey.shade300,
                                child: const Center(
                                  child: Icon(
                                    Icons.image_not_supported_outlined,
                                    color: Colors.grey,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      school.info.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Display school.school_name as preformatted text
                    Text(
                      "@${school.school_name}",
                      style: GoogleFonts.sourceCodePro(
                        // Use a monospace font
                        fontSize: 12, // Smaller font size
                        color:
                            Colors
                                .grey[700], // Darker grey for preformatted text
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
