// assistant/assistant.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ins/pages/sign/assistant/manager.dart';
import 'package:ins/pages/dashboard/dashboard.dart';
import '../../../backend/models.dart' as models;

class SignupAssistantPage extends StatefulWidget {
  const SignupAssistantPage({super.key});

  @override
  State<SignupAssistantPage> createState() => _SignupAssistantPageState();
}

class _SignupAssistantPageState extends State<SignupAssistantPage> {
  final _pageController = PageController();
  late SignupAssistantState _assistantState;
  final _steps = const ['role', 'name', 'password', 'dob', 'review'];
  int _currentStepIndex = 0;
  bool _isCreatingAccount = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    SignupAssistantState.loadOrCreate().then((state) {
      _assistantState = state;
      _currentStepIndex = _calculateInitialStep();
      _isInitialized = true;
      if (mounted) setState(() {});
      return state;
    });
  }

  int _calculateInitialStep() {
    if (_assistantState.role == null) return 0;
    if (_assistantState.name == null) return 1;
    if (_assistantState.password == null) return 2;
    if (_assistantState.dob == null) return 3;
    return 4;
  }

  void _nextStep() {
    if (_currentStepIndex < _steps.length - 1) {
      setState(() => _currentStepIndex++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStepIndex > 0) {
      setState(() => _currentStepIndex--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget _buildStepContent() {
    if (!_isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return PageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _RoleStep(
          initialRole: _assistantState.role,
          onSelected: (role) {
            _assistantState.setRole(role);
            _nextStep();
          },
        ),
        _NameStep(
          initialName: _assistantState.name,
          initialUsername: _assistantState.username,
          onSubmitted: (name, username) {
            _assistantState
              ..setName(name)
              ..setUsername(username);
            _nextStep();
          },
        ),
        _PasswordStep(
          initialPassword: _assistantState.password,
          onSubmitted: (password) {
            _assistantState.setPassword(password);
            _nextStep();
          },
        ),
        _DobStep(
          initialDob: _assistantState.dob,
          onSelected: (dob) {
            _assistantState.setDoB(dob);
            _nextStep();
          },
        ),
        _ReviewStep(
          assistantState: _assistantState,
          onCreateAccount: _createAccount,
          isCreating: _isCreatingAccount,
        ),
      ],
    );
  }

  Future<void> _createAccount() async {
    setState(() => _isCreatingAccount = true);
    try {
      final user = await _assistantState.createAccount();
      await SignupAssistantState.clear();
      if (!mounted) return;
      models.Session session = await user.setNewSession();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardPage(user: user, session: session),
        ),
      );
    } catch (e) {
      setState(() => _isCreatingAccount = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error creating account: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _currentStepIndex > 0 ? _previousStep : null,
        ),
        title: LinearProgressIndicator(
          value: (_currentStepIndex + 1) / _steps.length,
          backgroundColor: Colors.grey[200],
          minHeight: 4,
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _buildStepContent(),
      ),
    );
  }
}

class _RoleStep extends StatelessWidget {
  final String? initialRole;
  final ValueChanged<String> onSelected;

  const _RoleStep({required this.onSelected, this.initialRole});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Text(
            'Select Your Role',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 32),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _RoleCard(
                title: 'Student',
                icon: Icons.school,
                isSelected: initialRole == 'student',
                onTap: () => onSelected('student'),
              ),
              _RoleCard(
                title: 'Instructor',
                icon: Icons.person,
                isSelected: initialRole == 'instructor',
                onTap: () => onSelected('instructor'),
              ),
              _RoleCard(
                title: 'Parent',
                icon: Icons.family_restroom,
                isSelected: initialRole == 'parent',
                onTap: () => onSelected('parent'),
              ),
              _RoleCard(
                title: 'Administrator',
                icon: Icons.admin_panel_settings,
                isSelected: initialRole == 'administrator',
                onTap: () => onSelected('administrator'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey[300]!,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 40, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 8),
            Text(title, style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}

class _NameStep extends StatefulWidget {
  final String? initialName;
  final String? initialUsername;
  final void Function(String, String) onSubmitted;

  const _NameStep({
    required this.onSubmitted,
    this.initialName,
    this.initialUsername,
  });

  @override
  State<_NameStep> createState() => _NameStepState();
}

class _NameStepState extends State<_NameStep> {
  late final TextEditingController _nameController;
  String _username = '';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _nameController.addListener(_updateUsername);
    _updateUsername();
  }

  void _updateUsername() {
    final name = _nameController.text.trim();
    final username =
        name.isNotEmpty
            ? name.replaceAll(RegExp(r'\s+'), '').toLowerCase()
            : '';
    setState(() => _username = username);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Your Name', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 24),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Full Name',
              hintText: 'John Doe',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
            autofocus: true,
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 16),
          Text('Username', style: Theme.of(context).textTheme.bodyLarge),
          Text(
            _username.isEmpty ? 'yourusername' : _username,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed:
                _nameController.text.trim().length >= 3
                    ? () => widget.onSubmitted(
                      _nameController.text.trim(),
                      _username,
                    )
                    : null,
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }
}

class _PasswordStep extends StatefulWidget {
  final String? initialPassword;
  final ValueChanged<String> onSubmitted;

  const _PasswordStep({required this.onSubmitted, this.initialPassword});

  @override
  State<_PasswordStep> createState() => _PasswordStepState();
}

class _PasswordStepState extends State<_PasswordStep> {
  late final TextEditingController _passwordController;
  bool _obscureText = true;
  double _passwordStrength = 0.0;
  final _commonPasswords = {'password', '123456', 'qwerty', 'letmein'};

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController(text: widget.initialPassword);
    _passwordController.addListener(_updatePasswordStrength);
  }

  void _updatePasswordStrength() {
    final password = _passwordController.text;
    final requirements = [
      password.length >= 8, // Length
      password.contains(RegExp(r'[A-Z]')), // Uppercase
      password.contains(RegExp(r'[a-z]')), // Lowercase
      password.contains(RegExp(r'[0-9]')), // Number
      password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')), // Special char
      !_commonPasswords.contains(password.toLowerCase()), // Not common
    ];

    _passwordStrength = requirements.where((met) => met).length / 6;
    setState(() {});
  }

  String _generateStrongPassword() {
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'
        '0123456789!@#\$%^&*(),.?":{}|<>';
    final rnd = Random();
    return List.generate(
      12,
      (index) => chars[rnd.nextInt(chars.length)],
    ).join();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Create Password',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _passwordController,
            obscureText: _obscureText,
            decoration: InputDecoration(
              labelText: 'Password',
              border: const OutlineInputBorder(),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.autorenew),
                    onPressed:
                        () =>
                            _passwordController.text =
                                _generateStrongPassword(),
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
          ),
          const SizedBox(height: 20),
          LinearProgressIndicator(
            value: _passwordStrength,
            backgroundColor: Colors.grey[200],
            color:
                _passwordStrength < 0.4
                    ? Colors.red
                    : _passwordStrength < 0.75
                    ? Colors.orange
                    : Colors.green,
            minHeight: 8,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _buildValidationItem(
                '8+ characters',
                _passwordController.text.length >= 8,
              ),
              _buildValidationItem(
                'Uppercase letter',
                _passwordController.text.contains(RegExp(r'[A-Z]')),
              ),
              _buildValidationItem(
                'Lowercase letter',
                _passwordController.text.contains(RegExp(r'[a-z]')),
              ),
              _buildValidationItem(
                'Number',
                _passwordController.text.contains(RegExp(r'[0-9]')),
              ),
              _buildValidationItem(
                'Special character',
                _passwordController.text.contains(
                  RegExp(r'[!@#$%^&*(),.?":{}|<>]'),
                ),
              ),
              _buildValidationItem(
                'Not common',
                !_commonPasswords.contains(
                  _passwordController.text.toLowerCase(),
                ),
              ),
            ],
          ),
          const Spacer(),
          ElevatedButton(
            onPressed:
                _passwordStrength >= 0.75
                    ? () => widget.onSubmitted(_passwordController.text)
                    : null,
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  Widget _buildValidationItem(String text, bool isValid) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isValid ? Icons.check_circle : Icons.error,
          color: isValid ? Colors.green : Colors.grey,
          size: 20,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(color: isValid ? Colors.green : Colors.grey),
        ),
      ],
    );
  }
}

class _DobStep extends StatelessWidget {
  final DateTime? initialDob;
  final ValueChanged<DateTime> onSelected;

  const _DobStep({required this.onSelected, this.initialDob});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Date of Birth',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),
          CalendarDatePicker(
            initialDate: initialDob ?? DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
            onDateChanged: onSelected,
          ),
        ],
      ),
    );
  }
}

class _ReviewStep extends StatelessWidget {
  final SignupAssistantState assistantState;
  final VoidCallback onCreateAccount;
  final bool isCreating;

  const _ReviewStep({
    required this.assistantState,
    required this.onCreateAccount,
    required this.isCreating,
  });

  double _calculatePasswordStrength(String password) {
    final requirements = [
      password.length >= 8,
      password.contains(RegExp(r'[A-Z]')),
      password.contains(RegExp(r'[a-z]')),
      password.contains(RegExp(r'[0-9]')),
      password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')),
      !{'password', '123456'}.contains(password.toLowerCase()),
    ];
    return requirements.where((met) => met).length / 6;
  }

  @override
  Widget build(BuildContext context) {
    final passwordStrength = _calculatePasswordStrength(
      assistantState.password ?? '',
    );

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Text(
            'Review Details',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 32),
          _buildDetailItem('Role', assistantState.role ?? 'Not set'),
          _buildDetailItem('Name', assistantState.name ?? 'Not set'),
          _buildDetailItem('Username', assistantState.username ?? 'Not set'),
          _buildDetailItem(
            'Password Strength',
            '${(passwordStrength * 100).toStringAsFixed(0)}% Secure',
          ),
          _buildDetailItem(
            'Date of Birth',
            assistantState.dob?.toLocal().toString().split(' ')[0] ?? 'Not set',
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              icon:
                  isCreating
                      ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                      : const Icon(Icons.check_circle),
              label: Text(
                isCreating ? 'Creating Account...' : 'Create Account',
              ),
              onPressed: isCreating ? null : onCreateAccount,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(flex: 3, child: Text(value, textAlign: TextAlign.end)),
        ],
      ),
    );
  }
}
