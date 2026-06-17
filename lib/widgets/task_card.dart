import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;
  final VoidCallback? onTap;

  const TaskCard({
    super.key,
    required this.task,
    this.onTap,
  });

  Color priorityColor() {
    switch (task.priority) {
      case "High":
        return Colors.red;

      case "Medium":
        return Colors.orange;

      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,

      margin: const EdgeInsets.only(bottom: 12),

      child: ListTile(
        onTap: onTap,

        leading: Icon(
          task.isCompleted
              ? Icons.check_circle
              : Icons.radio_button_unchecked,
          color: task.isCompleted
              ? Colors.green
              : Colors.grey,
        ),

        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted
                ? TextDecoration.lineThrough
                : null,
            fontWeight: FontWeight.bold,
          ),
        ),

        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 5),

            Text(task.description),

            const SizedBox(height: 8),

            Chip(
              label: Text(task.priority),
              backgroundColor:
                  priorityColor().withOpacity(0.15),
              side: BorderSide(
                color: priorityColor(),
              ),
            ),

            Text(
              "${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}",
            ),

          ],
        ),
      ),
    );
  }
}