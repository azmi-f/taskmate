import 'package:flutter/material.dart';
import '../../models/task_model.dart';
import '../../services/task_service.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  final TaskService _taskService = TaskService();

  DateTime _selectedDate = DateTime.now();

  String _priority = "Medium";

  bool _isLoading = false;

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

  Future<void> saveTask() async {

    if (_titleController.text.trim().isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Judul task wajib diisi"),
        ),
      );

      return;
    }

    setState(() {
      _isLoading = true;
    });

    final task = TaskModel(
      userId: _taskService.uid,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      priority: _priority,
      dueDate: _selectedDate,
      isCompleted: false,
      createdAt: DateTime.now(),
    );

    await _taskService.addTask(task);

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Task berhasil ditambahkan"),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Tambah Task"),
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

              trailing: const Icon(Icons.edit_calendar),

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

                onPressed: _isLoading ? null : saveTask,

                child: _isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        "Simpan Task",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),

              ),

            )

          ],

        ),

      ),

    );
  }
}