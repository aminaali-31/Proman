import 'package:flutter/material.dart';
import 'package:proapp/pages/task_add.dart';
import 'package:proapp/provider/projects.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ProjectDetailPage extends StatefulWidget {
  final int projectId;

  const ProjectDetailPage({super.key, required this.projectId});

  @override
  State<ProjectDetailPage> createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends State<ProjectDetailPage> {
  String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ProjectProvider>().getDetails(id: widget.projectId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade900,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.7),
        title: const Text('Project Details'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade800,
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddTask(id: widget.projectId)),
          );

          if (result == true) {
            context.read<ProjectProvider>().getDetails(id: widget.projectId);
          }
        },
      ),
      body: Consumer<ProjectProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.error != null) {
            return Center(
              child: Text(
                provider.error!,
                style: const TextStyle(color: Colors.white),
              ),
            );
          }
          if (provider.project == null) {
            return const Center(
              child: Text(
                'No Project Data',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final project = provider.project!;
          final tasks = provider.tasks;

          return Column(
            children: [
              // --- Project Details ---
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.blue.shade800,
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Project: ${project.name}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                final confirm = await showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text("Delete Project"),
                                    content: const Text(
                                      "Are you sure you want to delete this project?",
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: const Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: const Text("Delete"),
                                      ),
                                    ],
                                  ),
                                );
                                if (confirm == true) {
                                  bool success = await ProjectProvider()
                                      .deleteProject(project.id);
                                  if (success) {
                                    Navigator.pop(
                                      context,
                                    ); // Go back to previous page
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Project deleted successfully",
                                        ),
                                      ),
                                    );
                                  }
                                }
                              },
                            ),

                            // Mark as Complete Icon
                            if (project.status != 'completed')
                              IconButton(
                                icon: const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                ),
                                onPressed: () async {
                                  bool success =
                                      await Provider.of<ProjectProvider>(
                                        context,
                                        listen: false,
                                      ).markProjectComplete(project.id);
                                  if (success) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Project marked as complete",
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Start Date: ${formatDate(project.startDate)}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      'Deadline: ${formatDate(project.deadline)}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Progress',
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: project.progress.toDouble(),
                      backgroundColor: Colors.white24,
                      color: Colors.greenAccent,
                      minHeight: 8,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${(project.progress).toInt()}%',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              // --- Tasks List ---
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          'Tasks',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: tasks.length,
                          itemBuilder: (context, index) {
                            final task = tasks[index];
                            return Card(
                              elevation: 3,
                              margin: EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      task.taskName,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    SizedBox(height: 6),

                                    Text(
                                      task.description!,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[700],
                                      ),
                                    ),

                                    SizedBox(height: 12),

                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Assigned: ${task.assignedTo}",
                                            ),
                                            Text(
                                              "Deadline: ${formatDate(task.deadline!)}",
                                            ),
                                          ],
                                        ),

                                        _statusIcon(task.status),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

Widget _statusIcon(String? status) {
  switch (status) {
    case 'pending':
      return const Icon(Icons.pause_circle, color: Colors.orange);
    case 'in_progress':
      return const Icon(Icons.autorenew, color: Colors.blue);
    case 'completed':
      return const Icon(Icons.check_circle, color: Colors.green);
    default:
      return const Icon(Icons.help_outline, color: Colors.grey);
  }
}
