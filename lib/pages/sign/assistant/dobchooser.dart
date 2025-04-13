import 'package:flutter/material.dart';
import './creatingaccount.dart';
import './base.dart';
import './manager.dart';

class DobChooser extends StatelessWidget {
  final SignupAssistantState assistantState;

  const DobChooser({super.key, required this.assistantState});

  void _next(BuildContext context) {
    if (assistantState.dob == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please select a date of birth.')));
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => CreatingAccountPage(assistantState: assistantState),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          assistantState.dob ??
          DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      assistantState.setDoB(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AssistantBasePage(
      title: Text('Date of Birth'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'When were you born?',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _selectDate(context),
                child: Text(
                  assistantState.dob != null
                      ? assistantState.dob!.toString().split(' ')[0]
                      : 'Select Date',
                ),
              ),
              Spacer(),
              FilledButton(
                onPressed: () => _next(context),
                child: Text("continue >"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
