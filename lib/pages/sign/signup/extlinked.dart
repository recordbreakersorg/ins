import 'package:flutter/material.dart';
import 'form.dart';
import 'base.dart';
import 'package:ins/utils/email.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'submit.dart';
import 'package:ins/animations/page/slide.dart';

class ExtraLinkedPage extends StatefulWidget {
  final SignupForm form;

  const ExtraLinkedPage({super.key, required this.form});

  @override
  State<ExtraLinkedPage> createState() => _ExtraLinkedPageState();
}

class _ExtraLinkedPageState extends State<ExtraLinkedPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _phoneValid = true;
  String? _emailError;
  @override
  Widget build(BuildContext context) {
    return SignupAssistantBase(
      body: Padding(
        padding: const EdgeInsets.all(
          20,
        ), //const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Text(
                "Optional information.",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person_outline),
                  labelText: "Email Address",
                  hintText: 'temexvironie12@ama.co',
                  border: OutlineInputBorder(),
                  suffixIcon: _emailError == null
                      ? const Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Icon(Icons.check_circle, color: Colors.green),
                        )
                      : const Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Icon(
                            Icons.cancel_rounded,
                            color: Colors.green,
                          ),
                        ),
                  error: _buildEmailError(),
                ),
                autofocus: true,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                onChanged: (_) {
                  verifyEmail();
                },
              ),
              const SizedBox(height: 30),
              InternationalPhoneNumberInput(
                onInputChanged: (PhoneNumber number) {
                  setState(() {
                    _phoneValid =
                        number.phoneNumber == null ||
                        number.phoneNumber!.length == 9 + 4;
                  });
                },
                onInputValidated: (bool value) {
                  setState(() {
                    //_phoneValid = value;
                  });
                },
                ignoreBlank: true,
                textFieldController: _phoneController,
                formatInput: true,
                keyboardType: const TextInputType.numberWithOptions(
                  signed: true,
                  decimal: true,
                ),
                inputDecoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                  error: _phoneValid
                      ? null
                      : Text(
                          "Phone number should be 9 digits long (without country code)",
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(color: Colors.red),
                        ),
                ),
                countries: ["CM"],
              ),
            ],
          ),
        ),
      ),
      title: const Text("Add email and/or phone number"),
      showNextButton: true,
      next:
          (_emailError == null || _emailController.text.isEmpty) &&
              (_phoneValid || _phoneController.text.isEmpty)
          ? () => _next(context)
          : null,
    );
  }

  void verifyEmail() {
    setState(() {
      if (_emailController.text.isEmpty) {
        _emailError = null;
      } else {
        _emailError = chechEmail(_emailController.text);
      }
    });
  }

  Widget? _buildEmailError() {
    return _emailController.text.isNotEmpty && _emailError != null
        ? Text(
            _emailError!,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.red),
          )
        : null;
  }

  void _next(BuildContext context) {
    if (_emailController.text.isNotEmpty) {
      widget.form.email = _emailController.text;
    }
    if (_phoneController.text.isNotEmpty) {
      widget.form.phone = _phoneController.text;
    }
    Navigator.of(
      context,
    ).push(SlidePageRoute(child: SubmitingPage(form: widget.form)));
  }
}
