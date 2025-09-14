import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onToggleComplete;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TaskTile({
    super.key,
    required this.task,
    required this.onToggleComplete,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: task.isCompleted,
        onChanged: (_) => onToggleComplete(),
      ),
      title: Text(
        task.title,
        style: TextStyle(
          decoration:
              task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
          IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: onDelete),
        ],
      ),
    );
  }
}
