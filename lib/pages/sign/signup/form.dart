import 'package:ins/models.dart' as models;
import 'package:ins/appstate.dart';
import 'package:ins/backend.dart' as backend;

class SignupForm {
  String? username;
  String? email;
  String? fullname;
  String? password;
  String? phone;
  Future<SignupFormSubmitResult> submit() {
    throw "Error signin you up";
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
