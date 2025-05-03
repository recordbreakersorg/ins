import 'package:flutter/material.dart';
import 'base.dart';

class ParentChatroomsPage extends ParentSchoolViewBase {
  const ParentChatroomsPage({
    super.key,
    required super.school,
    required super.member,
    required super.session,
    required super.user,
    super.index = 1,
  });

  @override
  Widget buildContent(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Hero(
                  tag: school.profile.getPath(),
                  child: Image.network(
                    school.profile.getPath(),
                    width: 200,
                    height: 200,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
