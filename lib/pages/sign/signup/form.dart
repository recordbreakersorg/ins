import 'package:ins/models.dart' as models;
import 'package:ins/appstate.dart';
import 'package:ins/backend.dart' as backend;

class SignupForm {
  String? username;
  String? email;
  String? fullname;
  String? password;
  String? phone;
  Future<SignupFormSubmitResult> submit() async {
    final result = await backend.query("v1/signup", {
      "username": username,
      "email": email,
      "fullname": fullname,
      "password": password,
      "phone": phone,
    }, null);
    if (result["status"] < 0) {
      throw result["message"];
    }
    return SignupFormSubmitResult(
      session: models.Session.fromJson(
        result["session"] as Map<String, dynamic>,
      ),
      user: models.User.fromJson(result["user"] as Map<String, dynamic>),
    );
  }
}

class SignupFormSubmitResult {
  final models.Session session;
  final models.User user;
  const SignupFormSubmitResult({required this.session, required this.user});
  Future<void> saveInState() async {
    AppState state = await AppState.load();
    state.session = session;
    state.user = user;
    state.save();
  }
}
