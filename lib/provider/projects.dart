import 'package:flutter/material.dart';
import 'package:proapp/models/profile.dart';
import '../models/pro_model.dart';
import '../services/api_service.dart';
import '../models/task.dart';

class ProjectProvider with ChangeNotifier {
  List<Project> _projects = [];
  ProfileModel? _profile;
  int revenue = 0;
  int receivables = 0;
  int tasksPen = 0;
  List<Project> upcomingProjects = [];
  int totalUpcoming = 0;
  bool isLoading = false;
  List<Task> _allTasks = [];
  List<Project> get projects => _projects;
  List<Task> get allTasks => _allTasks;
  ProfileModel? get profile => _profile;
  Project? _project;
  List<Task> _tasks = [];
  final ProjectService _service = ProjectService();
  Project? get project => _project;
  List<Task> get tasks => _tasks;
  String? error;

  Future<void> fetchProjects() async {
    isLoading = true;
    notifyListeners();

    try {
      List<dynamic> list = await _service.getProjects();
      _projects = list.map((json) => Project.fromJson(json)).toList();
    } catch (e) {
      print("Error fetching projects: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  void setProjects(List<Project> projects) {
    _projects = projects;
    notifyListeners();
  }

  Future<void> fetchDashboard() async {
    isLoading = true;
    notifyListeners();
    try {
      final data = await ProjectService().dashboard();
      // Revenue: API might return int or string
      revenue = double.parse(data['revenue']).toInt();

      // Receivables: API returns string like "18000.00"
      receivables =
          int.tryParse(
            double.tryParse(
                  data['rece']?.toString() ?? "0",
                )?.toInt().toString() ??
                "0",
          ) ??
          0;

      // Upcoming projects
      upcomingProjects = (data['pro'] as List<dynamic>)
          .map((json) => Project.fromJson(json))
          .toList();

      // Total upcoming projects
      totalUpcoming =
          int.tryParse(
            data['total']?.toString() ?? upcomingProjects.length.toString(),
          ) ??
          upcomingProjects.length;
      tasksPen = data['tasks'];
    } catch (e) {
      print("Error fetching dashboard: $e");
    }
    isLoading = false;
    notifyListeners();
  }
  Future<void> fetchProfile() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final data = await ProjectService().profile();
      _profile = data;
    } catch (e) {
      error = "Failed to load profile";
      print("Profile fetch error: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  Future<Map<String, dynamic>> addProject({
    required String name,
    required String description,
    required double budget,
    required String startDate,
    required String deadline,
    required String clientId,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      final result = await ProjectService().addProject(
        name: name,
        description: description,
        budget: budget,
        startDate: startDate,
        deadline: deadline,
        clientId: clientId,
      );

      // result should be like: {status: "success", project_id: 123, message: "Project created"}
      isLoading = false;
      notifyListeners();
      return result;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return {"status": "error", "message": e.toString()};
    }
  }

  Future<void> getDetails({required int id}) async {
    error = null;
    isLoading = true;
    notifyListeners();
    try {
      final result = await ProjectService().getDetails(id: id);
      final json = result['project'];

      // Map project details
      _project = Project(
        id: json['id'],
        name: json['project_name'],
        description: json['description'],
        budget: double.parse(json['budget'].toString()),
        startDate: DateTime.parse(json['start_date']),
        deadline: DateTime.parse(json['deadline']),
        clientId: (json['client_id'] as num).toInt(),
        progress: (double.parse(json['progress'])).toInt(),
        status: json['status'],
      );

      final tasksJson = result['tasks'] as List<dynamic>? ?? [];
      _tasks = tasksJson.map((taskJson) => Task.fromJson(taskJson)).toList();

      isLoading = false;
      notifyListeners();
    } catch (e) {
      error = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> TaskAdd({
    required int projectId,
    required int assignedTo,
    required String name,
    required String description,
    required String startDate,
    required String deadline,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      final result = await ProjectService().addTask(
        name: name,
        description: description,
        startDate: startDate,
        deadline: deadline,
        assignedTo: assignedTo,
        projectId: projectId,
      );
      isLoading = false;
      notifyListeners();
      if (result) {
        return true;
      }
      return false;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> getTasks() async {
    isLoading = true;
    notifyListeners();

    try {
      List<dynamic> list = await _service.allTasks();
      _allTasks = list.map((json) => Task.fromJson(json)).toList();
    } catch (e) {
      print("Error fetching tasks: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  void setTasks(List<Task> allTasks) {
    _allTasks = allTasks;
    notifyListeners();
  }

  Future<void> markTaskComplete(int taskId) async {
    try {
      await ProjectService().markComplete(id: taskId);

      final index = _allTasks.indexWhere((t) => t.id == taskId);

      if (index != -1) {
        _allTasks[index].status = "completed";
        notifyListeners();
      }
    } catch (e) {
      print("Error marking task complete: $e");
    }
  }

  /// Delete a project by ID
  Future<bool> deleteProject(int projectId) async {
    isLoading = true;
    notifyListeners();
    try {
      final response = await ProjectService().deleteProject(id: projectId);
      if (response) {
        _projects.removeWhere((project) => project.id == projectId);
        notifyListeners();
        return true;
      } else {
        print("Failed to delete project");
        return false;
      }
    } catch (e) {
      print("Error deleting project: $e");
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Mark a project as complete
  Future<bool> markProjectComplete(int projectId) async {
    isLoading = true;
    notifyListeners();
    try {
      final response = await ProjectService().markProjectAsComplete(
        id: projectId,
      );
      if (response) {
        // Update the local project object
        notifyListeners();
        return true;
      } else {
        print("Failed to mark project complete");
        return false;
      }
    } catch (e) {
      print("Error marking project complete: $e");
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
