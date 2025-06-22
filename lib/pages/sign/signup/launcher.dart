import 'package:flutter/material.dart';
import 'namepassword.dart';
import 'form.dart';

void launchSignupAssistant(BuildContext context) {
  SignupForm form = SignupForm();

  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => NamePasswordPage(form: form)),
  );
}
