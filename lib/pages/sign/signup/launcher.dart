import 'package:flutter/material.dart';
import 'package:ins/pages/sign/signup/terms.dart';
import 'form.dart';
import 'package:ins/animations/page/slide.dart';

void launchSignupAssistant(BuildContext context) {
  SignupForm form = SignupForm();

  Navigator.push(
    context,
    SlidePageRoute(builder: (_) => TermsPage(form: form)),
  );
}
