import 'package:flutter/material.dart';
import './base.dart';
import '../../../backend/models.dart';

class _NameImageEditor extends StatefulWidget {
  final Session session;
  final User student;

  const _NameImageEditor({required this.session, required this.student});

  @override
  State<StatefulWidget> createState() {
    return _NameImageEditorState();
  }
}

class _NameImageEditorState extends State<_NameImageEditor> {
  final TextEditingController _nameController = TextEditingController();
  bool editingName = false;
  Widget _editProfile() {
    return CircleAvatar(
      radius: 100,
      backgroundImage: NetworkImage(widget.student.profile.getPath()),
    );
  }

  Widget _editName() {
    return Row(
      children: [
        AnimatedSwitcher(
          duration: Duration(milliseconds: 400),
          child:
              editingName
                  ? TextField(controller: _nameController)
                  : Text(widget.student.name),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              editingName = !editingName;
            });
          },
          icon: Icon(Icons.edit),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _nameController.text = widget.student.name;
    });
    return Card.outlined(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
        child: Column(
          children: [_editProfile(), SizedBox(height: 20), _editName()],
        ),
      ),
    );
  }
}

class StudentSettingsProfile extends StatelessWidget {
  final Session session;
  final User student;
  const StudentSettingsProfile({
    super.key,
    required this.session,
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
    return StudentSettingsBaseLayout(
      title: "Profile",
      student: student,
      session: session,
      body: Center(
        child: Column(
          children: [_NameImageEditor(session: session, student: student)],
        ),
      ),
    );
  }
}
