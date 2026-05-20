import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proapp/provider/projects.dart';
import 'package:provider/provider.dart';
import '../../models/task.dart';
import '../theme.dart'; // your theme file

class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;

  const TaskTile({
    super.key,
    required this.task,
    this.onTap,
  });
  String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Theme.of(context).cardColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Task name
              Row(
                children: [
                  Expanded(
                    child: Text(
                      task.taskName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                        decoration: task.status == "completed"
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                  ),

                  Checkbox(
                    value: task.status == "completed",

                  onChanged: task.status == "completed"
                    ? null
                    : (_) {
                        context
                            .read<ProjectProvider>()
                            .markTaskComplete(task.id!);
                      },

                  ),
                ],
              ),
              const SizedBox(height: 4),

              // Task description
              Text(
                task.description!,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),

              // Dates row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Start: ${formatDate(task.startDate!)}",
                    style: TextStyle(
                      fontSize: 15,
                      color: Color.fromARGB(255, 19, 90, 51),
                    ),
                  ),
                  Text(
                    "Deadline: ${formatDate(task.deadline!)}",
                    style: TextStyle(fontSize: 15, color: Colors.redAccent),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Status
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(task.status!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  task.status!.toUpperCase(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'overdue':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
