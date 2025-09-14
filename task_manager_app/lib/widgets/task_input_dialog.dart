 

import 'package:flutter/material.dart';

class TaskInputDialog extends StatefulWidget {
  final String? initialTitle;

  const TaskInputDialog({super.key, this.initialTitle});

  @override
  State<TaskInputDialog> createState() => _TaskInputDialogState();
}

class _TaskInputDialogState extends State<TaskInputDialog> {
  late TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.initialTitle ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initialTitle == null ? "Add Task" : "Edit Task"),
      content: TextField(
        controller: _titleController,
        decoration: const InputDecoration(labelText: "Task Title"),
        autofocus: true,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            if (_titleController.text.trim().isEmpty) return;
            Navigator.of(context).pop({"title": _titleController.text.trim()});
          },
          child: const Text("Save"),
        ),
      ],
    );
  }
}

