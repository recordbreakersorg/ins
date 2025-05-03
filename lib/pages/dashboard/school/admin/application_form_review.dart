import 'package:flutter/material.dart';
import 'package:ins/backend/models.dart' as models;

class ApplicationFormReviewPage extends StatefulWidget {
  final models.SchoolApplicationFormAttempt attempt;
  final models.SchoolApplicationForm form;
  final models.Session session;
  final models.SchoolMember member;
  final models.User user;
  final models.School school;
  const ApplicationFormReviewPage({
    super.key,
    required this.attempt,
    required this.form,
    required this.session,
    required this.member,
    required this.user,
    required this.school,
  });

  @override
  State<ApplicationFormReviewPage> createState() =>
      _ApplicationFormReviewPageState();
}

class _ApplicationFormReviewPageState extends State<ApplicationFormReviewPage> {
  bool _isProcessing = false;
  String? _resultMessage;
  List<String>? _selectedClassroomIds;
  List<models.SchoolMember>? _selectedChildren;

  Future<void> _handleDecision(bool accepted) async {
    setState(() {
      _isProcessing = true;
      _resultMessage = null;
    });

    if (accepted) {
      // Step 1: Select Role
      final role = await showModalBottomSheet<String>(
        context: context,
        builder: (context) {
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                Text(
                  "Select the role for the new user:",
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: const Text("Student"),
                  onTap: () => Navigator.pop(context, 'student'),
                ),
                ListTile(
                  title: const Text("Teacher"),
                  onTap: () => Navigator.pop(context, 'teacher'),
                ),
                ListTile(
                  title: const Text("Parent"),
                  onTap: () => Navigator.pop(context, 'parent'),
                ),
                ListTile(
                  title: const Text("Admin"),
                  onTap: () => Navigator.pop(context, 'admin'),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      );

      if (role == null) {
        setState(() {
          _isProcessing = false;
        });
        return;
      }

      if (role == 'student') {
        // Step 2: Select Classrooms for Student
        final classrooms = await widget.school.getClassrooms(widget.session);
        final selectedClassroomIds = await showModalBottomSheet<List<String>>(
          context: context,
          isScrollControlled: true,
          builder: (context) {
            final List<String> selected = <String>[];
            return StatefulBuilder(
              builder: (context, setModalState) {
                return SafeArea(
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          "Select classroom(s):",
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ...classrooms.map<Widget>(
                          (c) => CheckboxListTile(
                            title: Text(c.info.name),
                            value: selected.contains(c.id),
                            onChanged: (v) {
                              setModalState(() {
                                if (v == true) {
                                  selected.add(c.id);
                                } else {
                                  selected.remove(c.id);
                                }
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 24,
                          ),
                          child: ElevatedButton(
                            onPressed:
                                selected.isNotEmpty
                                    ? () => Navigator.pop(
                                      context,
                                      selected.toList(),
                                    )
                                    : null,
                            child: const Text("Continue"),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );

        if (selectedClassroomIds == null || selectedClassroomIds.isEmpty) {
          setState(() {
            _isProcessing = false;
          });
          return;
        }
        _selectedClassroomIds = selectedClassroomIds;
        // Proceed to accept with selectedClassroomIds
        await _acceptApplication(
          role,
          _selectedClassroomIds,
          null,
        ); // Pass the role here
      } else if (role == 'parent') {
        // Step 2: Select Children for Parent
        final schoolMembers = await widget.school.getMembers(widget.session);
        final children =
            schoolMembers
                .where((m) => m.role == models.SchoolMemberRole.student)
                .toList();
        final selectedChildren = await showModalBottomSheet<
          List<models.SchoolMember>
        >(
          context: context,
          isScrollControlled: true,
          builder: (context) {
            final List<models.SchoolMember> selected = <models.SchoolMember>[];
            return StatefulBuilder(
              builder: (context, setModalState) {
                return SafeArea(
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          "Select child(ren):",
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        if (children.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              "No students available to select as children.",
                            ),
                          )
                        else
                          ...children.map<Widget>(
                            (child) => CheckboxListTile(
                              title: FutureBuilder<models.User>(
                                future: child.getUser(widget.session),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData)
                                    return const CircularProgressIndicator();
                                  else
                                    return Text(snapshot.data!.info.name);
                                },
                              ),
                              value: selected.contains(child),
                              onChanged: (v) {
                                setModalState(() {
                                  if (v == true) {
                                    selected.add(child);
                                  } else {
                                    selected.remove(child);
                                  }
                                });
                              },
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 24,
                          ),
                          child: ElevatedButton(
                            onPressed:
                                selected.isNotEmpty
                                    ? () => Navigator.pop(
                                      context,
                                      selected.toList(),
                                    )
                                    : null,
                            child: const Text("Continue"),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );

        if (selectedChildren == null || selectedChildren.isEmpty) {
          setState(() {
            _isProcessing = false;
          });
          return;
        }
        _selectedChildren = selectedChildren;
        // Proceed to accept with selectedChildren
        await _acceptApplication(
          role,
          null,
          _selectedChildren,
        ); // Pass the role here
      } else {
        // Step 2 & 3: Select Classrooms (optional) and Tags for other roles
        final classrooms = await widget.school.getClassrooms(widget.session);
        final selectedClassroomIds = await showModalBottomSheet<List<String>>(
          context: context,
          isScrollControlled: true,
          builder: (context) {
            final List<String> selected = <String>[];
            return StatefulBuilder(
              builder: (context, setModalState) {
                return SafeArea(
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          "Select classroom(s) (optional):",
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ...classrooms.map<Widget>(
                          (c) => CheckboxListTile(
                            title: Text(c.info.name),
                            value: selected.contains(c.id),
                            onChanged: (v) {
                              setModalState(() {
                                if (v == true) {
                                  selected.add(c.id);
                                } else {
                                  selected.remove(c.id);
                                }
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 24,
                          ),
                          child: ElevatedButton(
                            onPressed:
                                () => Navigator.pop(context, selected.toList()),
                            child: const Text("Continue"),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );

        final possibleTags = ['prefect'];
        final selectedTags = await showModalBottomSheet<List<String>>(
          context: context,
          isScrollControlled: true,
          builder: (context) {
            final Set<String> selected = <String>{};
            return StatefulBuilder(
              builder: (context, setModalState) {
                return SafeArea(
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          "Select tags (optional):",
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ...possibleTags.map(
                          (tag) => CheckboxListTile(
                            title: Text(tag),
                            value: selected.contains(tag),
                            onChanged: (v) {
                              setModalState(() {
                                if (v == true) {
                                  selected.add(tag);
                                } else {
                                  selected.remove(tag);
                                }
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 24,
                          ),
                          child: ElevatedButton(
                            onPressed:
                                () => Navigator.pop(context, selected.toList()),
                            child: const Text("Finish"),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
        // Call accept with selectedClassroomIds and selectedTags
        await _acceptApplication(
          role, // Pass the role here
          selectedClassroomIds,
          null,
          tags: selectedTags ?? [],
        );
      }
    } else {
      await widget.attempt.decline(widget.session);
      Navigator.of(context).pop();
      return;
    }

    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _isProcessing = false;
      _resultMessage =
          accepted ? "Application accepted." : "Application declined.";
    });
  }

  Future<void> _acceptApplication(
    String role,
    List<String>? classroomIds,
    List<models.SchoolMember>? children, {
    List<String>? tags,
  }) async {
    // This is the function that was missing.
    try {
      await widget.attempt.accept(
        widget.session,
        role,
        classroomIds ?? [],
        tags ?? [],
        children != null ? children.map((e) => e.id).toList() : [],
      );
      Navigator.of(context).pop();
    } catch (e) {
      setState(() {
        _isProcessing = false;
        _resultMessage = "Error: ${e.toString()}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final answers = widget.attempt.answers;
    final questions = widget.form.questions;
    return Scaffold(
      appBar: AppBar(title: const Text("Review Application")),
      body:
          _isProcessing
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ListView.separated(
                        itemCount: questions.length,
                        separatorBuilder: (_, __) => const Divider(),
                        itemBuilder: (context, idx) {
                          final q = questions[idx];
                          final a = answers.firstWhere(
                            (ans) => ans.questionNumber == q.number,
                            orElse:
                                () => models.SchoolApplicationFormAttemptAnswer(
                                  questionNumber: q.number,
                                  content: '',
                                ),
                          );
                          return ListTile(
                            title: Text(
                              q.question,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              a.content.isNotEmpty ? a.content : "(No answer)",
                            ),
                          );
                        },
                      ),
                    ),
                    if (_resultMessage != null) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          _resultMessage!,
                          style: TextStyle(
                            color:
                                _resultMessage!.startsWith("Error")
                                    ? Colors.red
                                    : Colors.green,
                          ),
                        ),
                      ),
                    ],
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.check),
                          label: const Text("Accept"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          onPressed:
                              _isProcessing
                                  ? null
                                  : () => _handleDecision(true),
                        ),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.close),
                          label: const Text("Decline"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed:
                              _isProcessing
                                  ? null
                                  : () => _handleDecision(false),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
    );
  }
}
