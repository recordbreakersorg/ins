enum UserRole { student, teacher, admin, staff }

extension UserRoleExtension on UserRole {
  String toJson() {
    switch (this) {
      case UserRole.student:
        return "student";
      case UserRole.teacher:
        return "teacher";
      case UserRole.admin:
        return "admin";
      case UserRole.staff:
        return "staff";
    }
  }
}

extension UserRoleStringExtension on String {
  UserRole toUserRole() {
    switch (toLowerCase()) {
      case "student":
        return UserRole.student;
      case "teacher":
        return UserRole.teacher;
      case "admin":
        return UserRole.admin;
      case "staff":
        return UserRole.staff;
      default:
        throw ArgumentError('Unknown role: $this');
    }
  }
}
