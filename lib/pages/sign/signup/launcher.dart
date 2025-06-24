import 'package:flutter/material.dart';
import 'namepassword.dart';
import 'form.dart';
import 'package:ins/animations/page/slide.dart';

void launchSignupAssistant(BuildContext context) {
  SignupForm form = SignupForm();

  Navigator.push(context, SlidePageRoute(child: NamePasswordPage(form: form)));
}
