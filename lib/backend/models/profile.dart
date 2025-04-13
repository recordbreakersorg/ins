import '../model.dart';
import '../backend.dart';

class Profile implements Model {
  final String pid;
  final String register;
  final String ext;

  const Profile({required this.pid, required this.register, required this.ext});

  String getPath() {
    return "${get_backend_url()}/profiles/$register/$pid.$ext";
  }

  static Profile fromJson(Map<String, dynamic> json) {
    return Profile(
      pid: json['pid'],
      register: json['register'],
      ext: json['ext'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {'pid': pid, 'register': register, 'ext': ext};
  }
}
