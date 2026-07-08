import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../config/app_colors.dart';

import '../../models/task_model.dart';
import '../../services/task_service.dart';

import '../../widgets/summary_card.dart';
import '../../widgets/task_tile.dart';

import '../auth/login_page.dart';
import '../task/add_task_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() =>
      _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final TaskService taskService = TaskService();

  final TextEditingController _searchController =
      TextEditingController();

  String _search = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginPage(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text("TaskMate"),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => logout(context),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddTaskPage(),
            ),
          );
        },
      ),

      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              20,
              20,
              10,
            ),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(
                  "Halo 👋",
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium,
                ),

                Text(
                  user?.email ?? "",
                  style: TextStyle(
                    color: Colors.grey.shade700,
                  ),
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: "Cari task...",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _search = value;
                    });
                  },
                ),
                                const SizedBox(height: 20),
              ],
            ),
          ),

          Expanded(
            child: StreamBuilder<List<TaskModel>>(
              stream: taskService.getTasks(),

              builder: (context, snapshot) {

                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      snapshot.error.toString(),
                    ),
                  );
                }

                final tasks = snapshot.data ?? [];

                final filteredTasks = tasks.where((task) {

                  final keyword =
                      _search.toLowerCase();

                  return task.title
                          .toLowerCase()
                          .contains(keyword) ||

                      task.description
                          .toLowerCase()
                          .contains(keyword);

                }).toList();

                final total = tasks.length;

                final selesai = tasks
                    .where(
                      (e) => e.isCompleted,
                    )
                    .length;

                final pending =
                    total - selesai;

                return ListView(
                  padding:
                      const EdgeInsets.all(20),

                  children: [

                    Row(
                      children: [

                        SummaryCard(
                          icon: Icons.list_alt,
                          title: "Total",
                          value: total.toString(),
                          color: AppColors.primary,
                        ),

                        const SizedBox(width: 10),

                        SummaryCard(
                          icon: Icons.check_circle,
                          title: "Selesai",
                          value: selesai.toString(),
                          color: AppColors.success,
                        ),

                        const SizedBox(width: 10),

                        SummaryCard(
                          icon:
                              Icons.pending_actions,
                          title: "Pending",
                          value: pending.toString(),
                          color:
                              AppColors.warning,
                        ),

                      ],
                    ),

                    const SizedBox(height: 30),

                    const Text(
                      "Daftar Task",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),
                                        if (filteredTasks.isEmpty)

                      Card(
                        child: Padding(
                          padding:
                              const EdgeInsets.all(30),

                          child: const Center(
                            child: Column(
                              children: [

                                Icon(
                                  Icons
                                      .assignment_outlined,
                                  size: 60,
                                  color: Colors.grey,
                                ),

                                SizedBox(height: 15),

                                Text(
                                  "Belum ada task",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),
                      )

                    else

                      ...filteredTasks.map(
                        (task) => TaskTile(
                          task: task,
                        ),
                      ),

                  ],
                );
              },
            ),
          ),

        ],
      ),
    );
  }
}