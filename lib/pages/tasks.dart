import 'package:flutter/material.dart';
import 'package:proapp/provider/projects.dart';
import 'package:proapp/widgets/task_tile.dart';
import 'package:provider/provider.dart';

enum SortOption { deadline, startDate, status, name }

class TasksList extends StatefulWidget {
  const TasksList({super.key});

  @override
  State<TasksList> createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  String searchQuery = ""; // store the search text
  String sortOption = "Name";

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      Provider.of<ProjectProvider>(context, listen: false).getTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        // Search bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search tasks...",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value.toLowerCase();
                    });
                  },
                ),
              ),

              const SizedBox(width: 10),

              // Sort button
              DropdownButton<String>(
                value: sortOption,
                items:
                    <String>[
                      'Name',
                      'Name Descending',
                      'Deadline Ascending',
                      'Deadline Descending',
                      'Start Ascending',
                      'Start Descending',
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(fontSize: 14),
                        ),
                      );
                    }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      sortOption = value;
                    });
                  }
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Tasks Grid
        Expanded(
          child: Consumer<ProjectProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              // Filter tasks by search query
              final filteredtasks = provider.allTasks.where((task) {
                final nameLower = task.taskName.toLowerCase();
                final clientLower = task.assignedTo.toString().toLowerCase();
                return nameLower.contains(searchQuery) ||
                    clientLower.contains(searchQuery);
              }).toList();

              filteredtasks.sort((a, b) {
                switch (sortOption) {
                  case 'Name':
                    return a.taskName.compareTo(b.taskName);
                  case 'Name Descending':
                    return b.taskName.compareTo(a.taskName);
                  case 'Deadline Ascending':
                    return a.deadline!.compareTo(b.deadline!);
                  case 'Deadline Descending':
                    return b.deadline!.compareTo(a.deadline!);
                  case 'Start Ascending':
                    return a.startDate!.compareTo(b.startDate!);
                  case 'Start Descending':
                    return b.startDate!.compareTo(a.startDate!);
                  default:
                    return 0;
                }
              });

              if (filteredtasks.isEmpty) {
                return const Center(child: Text("No tasks found"));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: filteredtasks.length,
                itemBuilder: (context, index) {
                  final task = filteredtasks[index];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: TaskTile(task: task),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
