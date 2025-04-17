import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:ins/pages/sign/assistant/base.dart';
import './manager.dart';
import './passwordchooser.dart';
// Import your user service here
import '../../../backend/models.dart';

class LowerCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toLowerCase(),
      selection: newValue.selection,
    );
  }
}

class NameChooserPage extends StatefulWidget {
  final SignupAssistantState assistantState;

  void onNameSelected(BuildContext context, String name, String username) {
    assistantState
      ..setName(name)
      ..setUsername(username);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => PasswordChooserPage(assistantState: assistantState),
      ),
    );
  }

  const NameChooserPage({super.key, required this.assistantState});

  @override
  State<NameChooserPage> createState() => _NameChooserPageState();
}

class _NameChooserPageState extends State<NameChooserPage> {
  TextEditingController? _nameController;
  late TextEditingController _usernameController;
  bool _isUsernameEdited = false;
  bool _isNameValid = false;
  bool _isUsernameValid = false;
  bool _isUsernameAvailable = false;
  bool _isCheckingUsername = false;
  String _normalizedUsername = '';
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController.fromValue(
      TextEditingValue(
        text: widget.assistantState.name ?? '',
        selection: TextSelection.collapsed(
          offset: (widget.assistantState.name ?? '').length,
        ),
      ),
    );
    _nameController?.addListener(_normalizeName);

    _usernameController = TextEditingController(
      text: widget.assistantState.username ?? _normalizedUsername,
    );
    _isUsernameEdited = widget.assistantState.username != null;

    _usernameController.addListener(_validateUsername);

    _normalizeName(); // Generate initial username
    _validateUsername();
    _checkUsernameAvailability(); // Initial check
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _nameController?.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void _normalizeName() {
    final name = _nameController?.text.trim() ?? '';
    final normalized =
        name.isNotEmpty
            ? name
                .split(' ')
                .map((part) => part.trim())
                .where((part) => part.isNotEmpty)
                .join('')
                .toLowerCase()
            : '';

    setState(() {
      _normalizedUsername = normalized;
      _isNameValid = name.length >= 3;

      if (!_isUsernameEdited) {
        _usernameController.text = normalized;
        _validateUsername();
        _checkUsernameAvailability();
      }
    });
  }

  void _validateUsername() {
    final username = _usernameController.text.trim();
    final RegExp regex = RegExp(r'^[a-z0-9_.]+$');
    bool isValid = username.length >= 3 && regex.hasMatch(username);
    setState(() => _isUsernameValid = isValid);

    if (isValid) {
      _checkUsernameAvailability();
    } else {
      setState(() => _isUsernameAvailable = false);
    }
  }

  Future<void> _checkUsernameAvailability() async {
    if (!_isUsernameValid) return;

    final username = _usernameController.text.trim();
    if (username.isEmpty) return;

    setState(() {
      _isCheckingUsername = true;
      _isUsernameAvailable = false;
    });

    // Cancel previous timer if exists
    _debounceTimer?.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      try {
        final isTaken = await User.usernameExists(username);

        if (mounted) {
          setState(() {
            _isCheckingUsername = false;
            _isUsernameAvailable = !isTaken;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isCheckingUsername = false;
            _isUsernameAvailable = false;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AssistantBasePage(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
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
                labelText: 'Full Name',
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
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                hintText: 'john_doe123',
                border: const OutlineInputBorder(),
                suffixIcon:
                    _isCheckingUsername
                        ? const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : _isUsernameAvailable
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
              ),
              autocorrect: false,
              keyboardType: TextInputType.text,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-z0-9_.]')),
                LowerCaseTextFormatter(),
              ],
              onChanged: (value) {
                setState(() => _isUsernameEdited = true);
                _validateUsername();
              },
            ),
            if (_usernameController.text.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: _buildUsernameStatus(),
              ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed:
                    (_isNameValid && _isUsernameValid && _isUsernameAvailable)
                        ? () => widget.onNameSelected(
                          context,
                          _nameController!.text.trim(),
                          _usernameController.text.trim(),
                        )
                        : null,
                child: const Text('Continue'),
              ),
            ),
          ],
        ),
      ),
      title: const Text("Profile Setup"),
    );
  }

  Widget _buildUsernameStatus() {
    if (_isCheckingUsername) {
      return Text(
        'Checking username availability...',
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: Colors.blue),
      );
    }

    if (!_isUsernameValid) {
      return Text(
        'Username must be at least 3 characters and can only contain:\nlowercase letters, numbers, underscores (_), and periods (.)',
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: Colors.red),
      );
    }

    if (!_isUsernameAvailable) {
      return Text(
        'This username is already taken',
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: Colors.red),
      );
    }

    return const SizedBox.shrink();
  }
}
