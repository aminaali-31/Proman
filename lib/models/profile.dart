class ProfileModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final int projects;
  final int completed;

  ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.projects,
    required this.completed,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['data']['id'],
      name: json['data']['name'],
      email: json['data']['email'],
      role: json['data']["role"],
      phone: json['data']['phone'] ?? "",
      projects: json['projects'],
      completed: json['completedPro']
    );
  }
}
