import 'package:flutter/material.dart';
import 'package:ins/pages/sign/assistant/base.dart';
import './manager.dart';
import './passwordchooser.dart';

class NameChooserPage extends StatefulWidget {
  final SignupAssistantState assistantState;
  // final Function(String name, String username) onNameSelected;
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
  String _normalizedUsername = '';
  bool _isNameValid = false;

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
    _normalizeName();
  }

  @override
  void dispose() {
    _nameController?.dispose();
    super.dispose();
  }

  void _normalizeName() {
    final name = _nameController?.text.trim();
    if (name == null) return;
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
      _isNameValid = name.length >= 3; // Minimum 3 characters
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
            SizedBox(height: 20),
            Text(
              "Choose a username",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            SizedBox(height: 30),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                hintText: 'Ninko Blessing',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
              autocorrect: false,
            ),
            const SizedBox(height: 20),
            Text(
              'Username Preview:',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              _normalizedUsername,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.blue),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed:
                    _isNameValid
                        ? () => widget.onNameSelected(
                          context,
                          _nameController?.text.trim() ?? '',
                          _normalizedUsername,
                        )
                        : null,
                child: const Text('Continue'),
              ),
            ),
          ],
        ),
      ),
      title: Text("Name"),
    );
  }
}
