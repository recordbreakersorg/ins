import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'form.dart';
import 'base.dart';

class NamePasswordPage extends StatefulWidget {
  final SignupForm form;

  const NamePasswordPage({super.key, required this.form});

  @override
  State<NamePasswordPage> createState() => _NamePasswordPageState();
}

class _NamePasswordPageState extends State<NamePasswordPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _password2Controller = TextEditingController();
  bool _obscureText = true;
  bool _isPasswordValid = false;
  bool _isNameValid = false;
  bool _arePasswordMatching = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(verifyEntries);
    _passwordController.addListener(verifyEntries);
    _password2Controller.addListener(verifyEntries);
  }

  @override
  Widget build(BuildContext context) {
    return SignupAssistantBase(
      body: Padding(
        padding: const EdgeInsets.all(
          0,
        ), //const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              "Create Your Profile",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Full Name",
                hintText: 'John Doe',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
              autocorrect: false,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: "Password",
                border: const OutlineInputBorder(),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () =>
                          setState(() => _obscureText = !_obscureText),
                    ),
                  ],
                ),
              ),
              obscureText: _obscureText,
              autofocus: true,
              keyboardType: TextInputType.visiblePassword,
              textCapitalization: TextCapitalization.none,
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp(r'\s')),
              ],
            ),
            if (_passwordController.text.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: _buildPasswordStatus(),
              ),
            const SizedBox(height: 20),
            TextField(
              controller: _password2Controller,
              decoration: InputDecoration(
                labelText: "Reenter password",
                border: const OutlineInputBorder(),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _arePasswordMatching
                        ? Icon(Icons.check_circle, color: Colors.green)
                        : Icon(Icons.cancel_rounded, color: Colors.red),
                  ],
                ),
              ),
              obscureText: _obscureText,
              autofocus: true,
              keyboardType: TextInputType.visiblePassword,
              textCapitalization: TextCapitalization.none,
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp(r'\s')),
              ],
            ),
            if (_password2Controller.text.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: _buildPassword2Status(),
              ),
          ],
        ),
      ),
      title: const Text("Profile Setup"),
      showNextButton: true,
      next: (_isNameValid && _isPasswordValid && _arePasswordMatching)
          ? () => gotoNext()
          : null,
    );
  }

  Widget _buildPasswordStatus() {
    if (!_isPasswordValid) {
      return Text(
        "Password must have atleast 8 characters",
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: Colors.red),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildPassword2Status() {
    if (!_arePasswordMatching) {
      return Text(
        "Password do not match",
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: Colors.red),
      );
    }
    return const SizedBox.shrink();
  }

  void gotoNext() {}

  void verifyEntries() {
    setState(() {
      _isPasswordValid = _passwordController.text.length >= 8;
      _isNameValid = _nameController.text.isNotEmpty;
      _arePasswordMatching =
          _passwordController.text == _password2Controller.text;
    });
  }
}
