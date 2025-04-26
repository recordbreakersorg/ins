Future<void> launchParentDashboard(
  BuildContext context,
  models.School school,
  models.User user,
  models.SchoolMember member,
) async {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;
  return Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ParentHomePage(
        school: school,
        user: user,
        member: member,
      ),
    ),
  );
}
class ParentHomePage extends StatefulWidget {
  final models.School school;
  final models.User user;
  final models.SchoolMember member;

  const ParentHomePage({
    super.key,
    required this.school,
    required this.user,
    required this.member,
  });

  @override
  _ParentHomePageState createState() => _ParentHomePageState();
}