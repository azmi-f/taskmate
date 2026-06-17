import 'package:flutter/material.dart';

import '../../models/task_model.dart';
import '../../services/task_service.dart';
import '../../widgets/task_tile.dart';

class TaskListPage extends StatelessWidget {
  TaskListPage({super.key});

  final TaskService taskService = TaskService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Task"),
      ),

      body: StreamBuilder<List<TaskModel>>(
        stream: taskService.getTasks(),

        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Terjadi kesalahan\n${snapshot.error}",
                textAlign: TextAlign.center,
              ),
            );
          }

          final tasks = snapshot.data ?? [];

          if (tasks.isEmpty) {
            return const Center(
              child: Text(
                "Belum ada task",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: tasks.length,

            itemBuilder: (context, index) {
              return TaskTile(
                task: tasks[index],
              );
            },
          );
        },
      ),
    );
  }
}