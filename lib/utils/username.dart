import 'package:ins/backend.dart' as backend;

String formatUsername(String name) {
  return name
      .toLowerCase()
      .replaceAll(" ", "_")
      .replaceAll(RegExp("[^a-z1-9_]+"), "");
}

Future<UsernameInfo> usernameInfo(String name) async {
  final data = await backend.query("v1/username/info", {
    "username": name,
  }, null);
  if (data['status'] < 0) {
    throw Exception("Failed to check username: ${data['message']}");
  }
  return UsernameInfo.fromJson(data['info'] as Map<String, dynamic>);
}

class UsernameInfo {
  final bool isValid;
  final bool isTaken;
  const UsernameInfo({required this.isValid, required this.isTaken});
  factory UsernameInfo.fromJson(Map<String, dynamic> json) {
    return UsernameInfo(
      isValid: json['is_valid'] as bool,
      isTaken: json['is_taken'] as bool,
    );
  }
}
