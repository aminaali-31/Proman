import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:proapp/models/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProjectService {
  static const baseUrl = "https://proapp.ariesware.com";

  Future<Map<String, dynamic>> dashboard() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse("$baseUrl/dashboard"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      print("Dashboard error: ${response.body}"); // optional for debugging
      throw Exception("Failed to load dashboard");
    }
  }

  Future<List<dynamic>> getProjects() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse("$baseUrl/projects"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    final data = jsonDecode(response.body);

    if (data['message'] == 'success') {
      List list = data['data'];
      return list;
    } else {
      throw Exception("Failed to load projects");
    }
  }

  Future<ProfileModel> profile() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse("$baseUrl/profile"), // Adjust endpoint if needed
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final jsondata = jsonDecode(response.body);
      return ProfileModel.fromJson(jsondata);
    } else {
      throw Exception(
        "Failed to fetch clients: ${response.statusCode} ${response.body}",
      );
    }
  }

  Future<List<Map<String, dynamic>>> getClients() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse("$baseUrl/projectForm"), // Adjust endpoint if needed
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonResponse = jsonDecode(response.body);
      final clientsData = jsonResponse['data'] ?? [];
      return List<Map<String, dynamic>>.from(clientsData);
    } else {
      throw Exception(
        "Failed to fetch clients: ${response.statusCode} ${response.body}",
      );
    }
  }

  /// Add a new project
  Future<Map<String, dynamic>> addProject({
    required String name,
    required String description,
    required double budget,
    required String startDate, // "YYYY-MM-DD"
    required String deadline, // "YYYY-MM-DD"
    required String clientId,
    int progress = 0,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.post(
      Uri.parse("$baseUrl/addProject"), // Adjust endpoint if needed
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "name": name,
        "desc": description,
        "budget": budget,
        "start": startDate,
        "deadline": deadline,
        "client_id": clientId,
        "progress": progress,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body); // Return the added project data
    } else {
      throw Exception(
        "Failed to add project: ${response.statusCode} ${response.body}",
      );
    }
  }

  Future<Map> getDetails({required int id}) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse("$baseUrl/project/$id"), // Adjust endpoint if needed
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        "Failed to fetch project: ${response.statusCode} ${response.body}",
      );
    }
  }

  Future<bool> addTask({
    required int projectId,
    required int assignedTo,
    required String name,
    required String description,
    required String startDate,
    required String deadline,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.post(
      Uri.parse("$baseUrl/addTask"), // Adjust endpoint if needed
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "name": name,
        "desc": description,
        "project_id": projectId,
        "start": startDate,
        "deadline": deadline,
        "assiged_to": assignedTo,
      }),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      print(response.body);
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getEmployess() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse("$baseUrl/taskForm"), // Adjust endpoint if needed
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonResponse = jsonDecode(response.body);
      final clientsData = jsonResponse['emp'] ?? [];
      return List<Map<String, dynamic>>.from(clientsData);
    } else {
      throw Exception(
        "Failed to fetch employees: ${response.statusCode} ${response.body}",
      );
    }
  }

  Future<List<dynamic>> allTasks() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse("$baseUrl/allTasks"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      List list = data['tasks'];
      return list;
    } else {
      throw Exception("Failed to load projects");
    }
  }

  Future<bool> deleteProject({required int id}) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.post(
      Uri.parse("$baseUrl/project/delete/$id"), // Adjust endpoint if needed
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> markProjectAsComplete({required int id}) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final response = await http.post(
      Uri.parse("$baseUrl/project/complete/$id"), // Adjust endpoint if needed
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> markComplete({required int id}) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.post(
      Uri.parse("$baseUrl/taskComplete/$id"), // Adjust endpoint if needed
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
