import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ins/animations/page/slide.dart';
import 'package:ins/models.dart' as models;
import 'package:ins/utils/username.dart';

import 'base.dart';
import 'form.dart';
import 'extlinked.dart';

class NamePasswordPage extends StatefulWidget {
  final SignupForm form;

  const NamePasswordPage({super.key, required this.form});

  @override
  State<NamePasswordPage> createState() => _NamePasswordPageState();
}

class _NamePasswordPageState extends State<NamePasswordPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _password2Controller = TextEditingController();
  String? _usernameCheckError;
  bool _obscureText = true;
  bool _isPasswordValid = false;
  bool _isNameValid = false;
  bool _arePasswordMatching = false;
  bool _isUserNameAvailable = false;
  bool _isCheckingUsername = false;
  bool _wasUsernameEdited = false;

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
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  labelText: "Full Name",
                  hintText: 'Temex Vironie',
                  border: OutlineInputBorder(),
                  helperText: "Your private name, not shown to others",
                ),
                autofocus: true,
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                autocorrect: false,
                onChanged: (_) {
                  if (!_wasUsernameEdited) generateUsername();
                },
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person_outline),
                  labelText: "Username",
                  hintText: 'temexvironie12',
                  border: OutlineInputBorder(),
                  helperText: "A short, public username for your profile",
                  suffixIcon: _isCheckingUsername
                      ? const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : _isUserNameAvailable
                      ? const Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Icon(Icons.check_circle, color: Colors.green),
                        )
                      : null,
                  error: _buildUsernameError(),
                ),
                autofocus: true,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.none,
                autocorrect: false,
                inputFormatters: [
                  FilteringTextInputFormatter(
                    " ",
                    replacementString: "_",
                    allow: false,
                  ),
                  FilteringTextInputFormatter.deny(RegExp(r'[^a-z0-9_]')),
                ],
                onChanged: (_) {
                  setState(() {
                    _wasUsernameEdited = true;
                    verifyNames();
                  });
                },
              ),

              const SizedBox(height: 30),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  labelText: "Password",
                  border: const OutlineInputBorder(),
                  error: _buildPasswordError(),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          !_obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () =>
                            setState(() => _obscureText = !_obscureText),
                      ),
                      SizedBox(width: 8),
                    ],
                  ),
                ),
                obscureText: _obscureText,
                autofocus: true,
                keyboardType: TextInputType.visiblePassword,
                textCapitalization: TextCapitalization.none,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _password2Controller,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  labelText: "Reenter password",
                  border: const OutlineInputBorder(),
                  error: _password2Controller.text.isNotEmpty
                      ? _buildPassword2Error()
                      : null,
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_password2Controller.text.isNotEmpty)
                        if (_arePasswordMatching)
                          Icon(Icons.check_circle, color: Colors.green)
                        else
                          Icon(Icons.cancel_rounded, color: Colors.red),
                    ],
                  ),
                ),
                obscureText: _obscureText,
                autofocus: true,
                keyboardType: TextInputType.visiblePassword,
                textCapitalization: TextCapitalization.none,
              ),
            ],
          ),
        ),
      ),
      title: const Text("Profile Setup"),
      showNextButton: true,
      next: !(_isNameValid && _isPasswordValid && _arePasswordMatching)
          ? null
          : () => _next(context),
    );
  }

  void generateUsername() {
    final name = _nameController.text;
    _usernameController.text = formatUsername(name);
  }

  @override
  void initState() {
    super.initState();
    _nameController.addListener(verifyNames);
    _usernameController.addListener(verifyUsername);
    _passwordController.addListener(verifyPasswords);
    _password2Controller.addListener(verifyPasswords);
  }

  void verifyNames() {
    verifyUsername();
    setState(() {
      _isNameValid = _nameController.text.isNotEmpty;
      _arePasswordMatching =
          _passwordController.text == _password2Controller.text;
    });
  }

  void verifyPasswords() {
    setState(() {
      _isPasswordValid = _passwordController.text.length >= 8;
      _arePasswordMatching =
          _passwordController.text == _password2Controller.text;
    });
  }

  Future<void> verifyUsername() async {
    if (_isCheckingUsername || _usernameController.text.isEmpty) {
      return; // Prevent multiple checks
    }
    setState(() {
      _isCheckingUsername = true;
    });
    await Future.delayed(const Duration(milliseconds: 2000));
    try {
      final usenameInfo = await models.User.usernameInfo(
        _usernameController.text,
      );
      setState(() {
        _isUserNameAvailable = !usenameInfo.isTaken;
        _usernameCheckError = null;
        _isCheckingUsername = false;
      });
    } catch (e) {
      setState(() {
        _usernameCheckError = e.toString();
        _isUserNameAvailable = false;
        _isCheckingUsername = false;
      });
    }
  }

  Widget? _buildPassword2Error() {
    if (_password2Controller.text.isEmpty) return null;
    if (!_arePasswordMatching) {
      return Text(
        "Password do not match",
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: Colors.red),
      );
    }
    return null;
  }

  Widget? _buildPasswordError() {
    if (_passwordController.text.isEmpty) return null;
    if (!_isPasswordValid) {
      return Text(
        "Password must have atleast 8 characters",
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: Colors.red),
      );
    }
    return null;
  }

  Widget? _buildUsernameError() {
    if (_usernameController.text.isEmpty) return null;
    if (_usernameCheckError != null) {
      return Text(
        _usernameCheckError!,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: Colors.red),
      );
    }
    final username = _usernameController.text;
    if (_wasUsernameEdited) {
      if (username.length < 3 || username.length > 20) {
        return Text(
          "Username must be between 3 and 20 characters",
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.red),
        );
      }
    }
    if (!_isUserNameAvailable) {
      return Text(
        "Username is already taken",
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: Colors.red),
      );
    }
    return null;
  }

  void _next(BuildContext context) {
    widget.form.fullname = _nameController.text;
    widget.form.username = _usernameController.text;
    widget.form.password = _passwordController.text;
    Navigator.of(
      context,
    ).push(SlidePageRoute(child: ExtraLinkedPage(form: widget.form)));
  }
}
