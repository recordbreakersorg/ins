import 'package:flutter/material.dart';

/// Shows a standard confirmation dialog.
/// Returns `true` if the user confirms, `false` if they cancel, and `null` if they dismiss it.
Future<bool?> showConfirmationDialog(
  BuildContext context,
  String title,
  String content,
) async {
  return await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // Return false
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true), // Return true
            child: const Text("Confirm"),
          ),
        ],
      );
    },
  );
}
