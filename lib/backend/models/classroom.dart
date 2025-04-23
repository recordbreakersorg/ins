import '../model.dart';
import './profile.dart';

class ClassroomMember implements Model {
  final String id;
  final String memberId;
  final String classroomId;

  const ClassroomMember({
    required this.id,
    required this.memberId,
    required this.classroomId,
  });
  factory ClassroomMember.fromJson(Map<String, dynamic> json) {
    return ClassroomMember(
      id: json['id'],
      memberId: json['member_id'],
      classroomId: json['classroom_id'],
    );
  }
  @override
  Map<String, dynamic> toJson() {
    return {'id': id, 'member_id': memberId, 'classroom_id': classroomId};
  }
}

class Classroom implements Model {
  final String id;
  final String name;
  final String role;
  final Profile profile;
  final String schoolId;

  const Classroom({
    required this.id,
    required this.name,
    required this.role,
    required this.profile,
    required this.schoolId,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'profile': profile.toJson(),
      'school_id': schoolId,
    };
  }

  factory Classroom.fromJson(Map<String, dynamic> json) {
    var cls = Classroom(
      id: json['id'],
      name: json['name'],
      role: json['role'],
      profile: Profile.fromJson(json['profile']),
      schoolId: json['school_id'],
    );
    return cls;
  }
}
