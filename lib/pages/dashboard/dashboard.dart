import 'package:flutter/material.dart';
import './feeds.dart';
import './base.dart';
import '../../backend/models.dart' as models;
import './loadingpage.dart';
import './errorpage.dart';

class DashboardPage extends DashboardBase {
  const DashboardPage({
    super.key,
    super.navIndex = 0,
    super.title = "Dashboard",
    required super.session,
    required super.user,
  });
  @override
  Widget buildContent(BuildContext context) {
    return FutureBuilder(
      future: user.getFeeds(session),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingPage(
            messages: [
              "Loading your feeds...",
              "Please wait",
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
