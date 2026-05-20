


class Task {
  int? id;
  int projectId;
  String taskName;
  String? description;
  String? assignedTo;
  String? status;
  String? priority;
  DateTime? startDate;
  DateTime? deadline;
  DateTime? createdAt;
  DateTime? updatedAt;

  Task({
    this.id,
    required this.projectId,
    required this.taskName,
    this.description,
    this.assignedTo,
    this.status = 'pending',
    this.priority = 'medium',
    this.startDate,
    this.deadline,
    this.createdAt,
    this.updatedAt,
  });

  // Convert from JSON (from API or DB)
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      projectId: json['project_id'],
      taskName: json['task_name'],
      description: json['description'],
      assignedTo: json['username'],
      status: json['status'],
      priority: json['priority'],
      startDate: json['start_date'] != null ? DateTime.parse(json['start_date']) : null,
      deadline: json['deadline'] != null ? DateTime.parse(json['deadline']) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  // Convert to JSON (for API or DB)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'project_id': projectId,
      'task_name': taskName,
      'description': description,
      'assigned_to': assignedTo,
      'status': status,
      'priority': priority,
      'start_date': startDate?.toIso8601String(),
      'deadline': deadline?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
