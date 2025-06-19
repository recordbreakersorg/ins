import 'package:flutter/material.dart';
import 'package:ins/backend/models.dart';
import 'package:ins/errorpage.dart';
import 'package:google_fonts/google_fonts.dart';
import './base.dart';

class StudentClassroomsPage extends StudentSchoolViewBase {
  const StudentClassroomsPage({
    super.key,
    required super.school,
    required super.member,
    required super.session,
    required super.user,
    super.index = 1,
  });

  Widget _buildClassroomCard(
    BuildContext context,
    Classroom classroom,
    ClassroomMember classroomMember,
  ) {
    return Card.outlined(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            children: [
              _buildClassroomCardBackground(context, classroom),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.1),
                      Colors.black.withOpacity(0.6),
                    ],
                  ),
                ),
              ),
              _buildClassroomCardContent(context, classroom),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClassroomCardContent(BuildContext context, Classroom classroom) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: 'classroom-logo-${school.id}',
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 56,
                    maxHeight: 56,
                  ),
                  child: CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(school.profile.getPath()),
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                classroom.info.name,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                '@${classroom.classroomName}',
                style: GoogleFonts.poppins(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Hero _buildClassroomCardBackground(
    BuildContext context,
    Classroom classroom,
  ) {
    return Hero(
      tag: 'classroom-bg-${school.id}',
      child: Image.network(
        classroom.profile.getPath(),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value:
                  loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
            ),
          );
        },
        errorBuilder:
            (context, error, stackTrace) => Container(
              color: Colors.grey[300],
              child: const Center(child: Icon(Icons.error_outline)),
            ),
      ),
    );
  }

  Widget _buildClassroomsListView(
    BuildContext context,
    List<ClassroomMember> classroomMembers,
  ) {
    return ListView.builder(
      padding: const EdgeInsetsGeometry.all(10),
      itemCount: classroomMembers.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsetsGeometry.only(bottom: 10),
          child: _buildClassroomMemberCard(context, classroomMembers[index]),
        );
      },
    );
  }

  Widget _buildClassroomMemberCard(
    BuildContext context,
    ClassroomMember classroomMember,
  ) {
    return FutureBuilder<Classroom>(
      future: classroomMember.getClassroom(session),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Icon(Icons.wifi_tethering_error);
        } else if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData) {
          return const CircularProgressIndicator();
        } else {
          return _buildClassroomCard(context, snapshot.data!, classroomMember);
        }
      },
    );
  }

  @override
  Widget buildContent(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: FutureBuilder<List<ClassroomMember>>(
              future: member.getClassroomMemberships(session),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return ErrorPage(
                    title: "Error loading your classrooms",
                    description: "${snapshot.error}",
                  );
                } else if (snapshot.connectionState ==
                        ConnectionState.waiting ||
                    !snapshot.hasData) {
                  return CircularProgressIndicator();
                } else {
                  return _buildClassroomsListView(context, snapshot.data!);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
