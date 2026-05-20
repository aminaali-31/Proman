class Project {
  final int id;
  final String name;
  final String description;
  final double budget;
  final DateTime startDate;
  final DateTime deadline;
  final int clientId;
  final int progress;
  final String status;

  Project({
    required this.id,
    required this.name,
    required this.description,
    required this.budget,
    required this.startDate,
    required this.deadline,
    required this.clientId,
    required this.progress,
    required this.status,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      name: json['project_name'],
      description: json['description'],
      budget: double.parse(json['budget'].toString()),
      startDate: DateTime.parse(json['start_date']),
      deadline: DateTime.parse(json['deadline']),
      clientId: (json['client_id'] as num).toInt(),
      progress: (double.parse(json['progress'])).toInt(),
      status:json['status'],
    );
  }
}
