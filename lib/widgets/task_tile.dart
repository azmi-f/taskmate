import 'package:flutter/material.dart';

import '../models/task_model.dart';
import '../services/task_service.dart';

class TaskTile extends StatelessWidget {
  final TaskModel task;

  const TaskTile({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    final TaskService taskService = TaskService();

    Color priorityColor;

    switch (task.priority) {
      case "High":
        priorityColor = Colors.red;
        break;
      case "Medium":
        priorityColor = Colors.orange;
        break;
      default:
        priorityColor = Colors.green;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(15),

        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (value) async {
            await taskService.updateStatus(
              task.id!,
              value ?? false,
            );
          },
        ),

        title: Text(
          task.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration: task.isCompleted
                ? TextDecoration.lineThrough
                : null,
          ),
        ),

        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            if (task.description.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(task.description),
            ],

            const SizedBox(height: 10),

            Row(
              children: [

                const Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Colors.grey,
                ),

                const SizedBox(width: 5),

                Text(
                  "${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}",
                ),

              ],
            ),

            const SizedBox(height: 10),

            Chip(
              backgroundColor: priorityColor.withAlpha(40),
              label: Text(
                task.priority,
                style: TextStyle(
                  color: priorityColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          ],
        ),

        trailing: PopupMenuButton<String>(
          onSelected: (value) async {

            switch (value) {

              case "edit":

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Fitur Edit Task akan dibuat berikutnya.",
                    ),
                  ),
                );

                break;

              case "delete":

                await taskService.deleteTask(task.id!);

                if (!context.mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Task berhasil dihapus"),
                    backgroundColor: Colors.red,
                  ),
                );

                break;
            }
          },

          itemBuilder: (_) => const [

            PopupMenuItem(
              value: "edit",
              child: Row(
                children: [
                  Icon(Icons.edit),
                  SizedBox(width: 10),
                  Text("Edit"),
                ],
              ),
            ),

            PopupMenuItem(
              value: "delete",
              child: Row(
                children: [
                  Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  SizedBox(width: 10),
                  Text("Hapus"),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}