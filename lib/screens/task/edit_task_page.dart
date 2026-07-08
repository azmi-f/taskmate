import 'package:flutter/material.dart';

import '../../models/task_model.dart';
import '../../services/task_service.dart';

class EditTaskPage extends StatefulWidget {
  final TaskModel task;

  const EditTaskPage({
    super.key,
    required this.task,
  });

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  final TaskService _taskService = TaskService();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  late DateTime _selectedDate;

  late String _priority;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(
      text: widget.task.title,
    );

    _descriptionController = TextEditingController(
      text: widget.task.description,
    );

    _selectedDate = widget.task.dueDate;

    _priority = widget.task.priority;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2035),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> updateTask() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Judul task wajib diisi",
          ),
        ),
      );

      return;
    }

    setState(() {
      _isLoading = true;
    });

    final task = TaskModel(
      id: widget.task.id,
      userId: widget.task.userId,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      priority: _priority,
      dueDate: _selectedDate,
      isCompleted: widget.task.isCompleted,
      createdAt: widget.task.createdAt,
    );

    await _taskService.updateTask(task);
    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Task berhasil diperbarui"),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Task"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Judul Task",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Contoh : Preventive AC Lantai 3",
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Deskripsi",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Deadline",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            ListTile(
              leading: const Icon(Icons.calendar_today),

              title: Text(
                "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
              ),

              trailing: const Icon(
                Icons.edit_calendar,
              ),

              onTap: pickDate,
            ),

            const SizedBox(height: 20),

            const Text(
              "Prioritas",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              value: _priority,

              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
                            items: const [

                DropdownMenuItem(
                  value: "Low",
                  child: Text("Low"),
                ),

                DropdownMenuItem(
                  value: "Medium",
                  child: Text("Medium"),
                ),

                DropdownMenuItem(
                  value: "High",
                  child: Text("High"),
                ),

              ],

              onChanged: (value) {
                setState(() {
                  _priority = value!;
                });
              },
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 50,

              child: ElevatedButton(

                onPressed: _isLoading
                    ? null
                    : updateTask,

                child: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                    : const Text(
                        "Simpan Perubahan",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),

              ),
            ),

          ],
        ),
      ),
    );
  }
}