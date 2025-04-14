import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './manager.dart';
import './base.dart';
import './dobchooser.dart';

class PasswordChooserPage extends StatefulWidget {
  final SignupAssistantState assistantState;
  void onPasswordValidated(BuildContext context, password) {
    assistantState.setPassword(password);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DobChooser(assistantState: assistantState),
      ),
    );
  }

  const PasswordChooserPage({super.key, required this.assistantState});

  @override
  State<PasswordChooserPage> createState() => _PasswordChooserPageState();
}

class _PasswordChooserPageState extends State<PasswordChooserPage> {
  TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  bool _isValid = false;
  double _passwordStrength = 0.0;
  String _strengthLabel = '';
  Color _strengthColor = Colors.red;

  // Validation flags
  bool _hasMinLength = false;
  bool _hasUpper = false;
  bool _hasLower = false;
  bool _hasNumber = false;
  bool _hasSpecial = false;
  bool _isNotCommon = true;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController.fromValue(
      TextEditingValue(
        text: widget.assistantState.password ?? '',
        selection: TextSelection.collapsed(
          offset: (widget.assistantState.password ?? '').length,
        ),
      ),
    );
    _passwordController.addListener(_validatePassword);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _validatePassword() {
    final password = _passwordController.text;

    setState(() {
      _hasMinLength = password.length >= 8;
      _hasUpper = password.contains(RegExp(r'[A-Z]'));
      _hasLower = password.contains(RegExp(r'[a-z]'));
      _hasNumber = password.contains(RegExp(r'[0-9]'));
      _hasSpecial = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
      _isNotCommon = !_commonPasswords.contains(password.toLowerCase());

      // Calculate password strength
      final lengthScore = _hasMinLength ? 0.2 : 0.0;
      final upperScore = _hasUpper ? 0.15 : 0.0;
      final lowerScore = _hasLower ? 0.15 : 0.0;
      final numberScore = _hasNumber ? 0.15 : 0.0;
      final specialScore = _hasSpecial ? 0.15 : 0.0;
      final commonScore = _isNotCommon ? 0.2 : 0.0;

      _passwordStrength = (lengthScore +
              upperScore +
              lowerScore +
              numberScore +
              specialScore +
              commonScore)
          .clamp(0.0, 1.0);

      // Determine strength label and color
      if (_passwordStrength < 0.4) {
        _strengthLabel = 'Weak';
        _strengthColor = Colors.red;
      } else if (_passwordStrength < 0.75) {
        _strengthLabel = 'Moderate';
        _strengthColor = Colors.orange;
      } else {
        _strengthLabel = 'Strong';
        _strengthColor = Colors.green;
      }

      _isValid = _passwordStrength >= 0.75 && _isNotCommon;
    });
  }

  final Set<String> _commonPasswords = {
    'password',
    '12345678',
    'qwertyui',
    '11111111',
    'abc12345',
    'letmein',
    'welcome',
    'admin123',
  };

  String _generateStrongPassword() {
    const upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const lower = 'abcdefghijklmnopqrstuvwxyz';
    const numbers = '0123456789';
    const special = '!@#\$%^&*(),.?":{}|<>';

    final allChars = upper + lower + numbers + special;
    final random = Random();

    String password;
    do {
      password = List.generate(12, (index) {
        if (index == 0) return upper[random.nextInt(upper.length)];
        if (index == 1) return lower[random.nextInt(lower.length)];
        if (index == 2) return numbers[random.nextInt(numbers.length)];
        if (index == 3) return special[random.nextInt(special.length)];
        return allChars[random.nextInt(allChars.length)];
      }).join('');
    } while (!_isPasswordStrong(password));

    return password;
  }

  bool _isPasswordStrong(String password) {
    return password.length >= 12 &&
        password.contains(RegExp(r'[A-Z]')) &&
        password.contains(RegExp(r'[a-z]')) &&
        password.contains(RegExp(r'[0-9]')) &&
        password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  }

  void _showPasswordSuggestions() {
    final generatedPassword = _generateStrongPassword();
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Suggested Password'),
            content: SelectableText(generatedPassword),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: generatedPassword));
                  Navigator.pop(context);
                },
                child: const Text('Copy'),
              ),
              FilledButton(
                onPressed: () {
                  _passwordController.text = generatedPassword;
                  Navigator.pop(context);
                },
                child: const Text('Use This'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _validatePassword();
    return AssistantBasePage(
      title: const Text('Password'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: const OutlineInputBorder(),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.autorenew),
                      onPressed: _showPasswordSuggestions,
                      tooltip: 'Generate password',
                    ),
                    IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed:
                          () => setState(() => _obscureText = !_obscureText),
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
            const SizedBox(height: 20),
            _buildStrengthIndicator(),
            const SizedBox(height: 15),
            _buildValidationItem('Minimum 8 characters', _hasMinLength),
            _buildValidationItem('Uppercase letter (A-Z)', _hasUpper),
            _buildValidationItem('Lowercase letter (a-z)', _hasLower),
            _buildValidationItem('Number (0-9)', _hasNumber),
            _buildValidationItem('Special character (!@#...)', _hasSpecial),
            const SizedBox(height: 10),
            //TextButton(
            //  onPressed: _showPasswordSuggestions,
            //  child: const Text('Suggest a secure password'),
            //),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed:
                    _isValid
                        ? () => widget.onPasswordValidated(
                          context,
                          _passwordController.text,
                        )
                        : null,
                child: const Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStrengthIndicator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$_strengthLabel password',
          style: TextStyle(color: _strengthColor, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        LinearProgressIndicator(
          value: _passwordStrength,
          backgroundColor: Colors.grey[200],
          color: _strengthColor,
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  Widget _buildValidationItem(String text, bool isValid) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.error,
            color: isValid ? Colors.green : Colors.grey,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: isValid ? Colors.green : Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
