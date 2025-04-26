import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../backend/models.dart' as models;
import '../../../backend/backend.dart';

class AssistantState {
  final models.SchoolApplicationForm form;
  Map<int, String> answers;
  AssistantState(this.form) : answers = {};
  Map<String, dynamic> toJson() {
    return {"form": form.toJson(), "answers": answers};
  }

  static Future<AssistantState> loadOrCreate(
    models.SchoolApplicationForm form,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString('apply_assistant_state/${form.id}');
    if (jsonStr != null) {
      try {
        final Map<String, dynamic> data = jsonDecode(jsonStr);
        final answers = Map<int, String>.from(data['answers']);
        return AssistantState(form)..answers = answers;
      } catch (_) {}
    }
    return AssistantState(form);
  }

  Future<void> setAnswer(int questionId, String answer) async {
    answers[questionId] = answer;
    await save();
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'apply_assistant_state/${form.id}',
      jsonEncode(toJson()),
    );
  }

  Future<void> submit(models.Session session) async {
    final oanswers = jsonEncode(
      answers.entries
          .map(
            (entry) => {"question_number": entry.key, "content": entry.value},
          )
          .toList(),
    );
    final response = await apiQuery(
      "school/${form.schoolId}/applicationform/submit",
      {"answers": oanswers},
      session,
    );
    if (response['status'] < 0) {
      throw Exception("Error: ${response['message']}");
    }
  }
}
