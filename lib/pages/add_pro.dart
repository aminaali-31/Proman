import 'package:flutter/material.dart';
import 'package:proapp/provider/projects.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';

class AddProject extends StatefulWidget {
  const AddProject({super.key});

  @override
  State<AddProject> createState() => _AddProjectState();
}

class _AddProjectState extends State<AddProject> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameCon = TextEditingController();
  TextEditingController descCon = TextEditingController();
  TextEditingController budgetCon = TextEditingController();
  TextEditingController startDateCon = TextEditingController();
  TextEditingController deadlineCon = TextEditingController();
  List<Map<String, dynamic>> clients = [];
  bool isLoadingClients = true;
  String? selectedClient;

  @override
  void initState() {
    super.initState();
    _loadClients();
  }

  Future<void> _loadClients() async {
    try {
      final fetchedClients = await ProjectService().getClients();
      setState(() {
        clients = fetchedClients;
        isLoadingClients = false;
      });
    } catch (e) {
      setState(() {
        isLoadingClients = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Project")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 16),

              // Project Name
              TextFormField(
                controller: nameCon,
                decoration: const InputDecoration(
                  labelText: "Project Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? "Enter project name"
                    : null,
              ),
              const SizedBox(height: 16),

              // Description
              TextFormField(
                controller: descCon,
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              // Budget
              TextFormField(
                controller: budgetCon,
                decoration: const InputDecoration(
                  labelText: "Budget",
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return "Enter budget";
                  if (double.tryParse(value) == null) return "Invalid number";
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Start Date
              TextFormField(
                controller: startDateCon,
                decoration: const InputDecoration(
                  labelText: "Start Date",
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2025),
                    lastDate: DateTime(2027),
                  );
                  if (date != null) {
                    startDateCon.text =
                        "${date.year}-${date.month}-${date.day}";
                  }
                },
              ),
              const SizedBox(height: 16),

              // Deadline
              TextFormField(
                controller: deadlineCon,
                decoration: const InputDecoration(
                  labelText: "Deadline",
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2025),
                    lastDate: DateTime(2027),
                  );
                  if (date != null) {
                    deadlineCon.text = "${date.year}-${date.month}-${date.day}";
                  }
                },
              ),
              const SizedBox(height: 16),

              isLoadingClients
                  ? CircularProgressIndicator()
                  : DropdownButtonFormField<String>(
                      initialValue: selectedClient,
                      items: clients
                          .map(
                            (client) => DropdownMenuItem(
                              value: client['id'].toString(), // or 'name'
                              child: Text(client['name']),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedClient = value;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: "Select Client",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null ? "Please select a client" : null,
                    ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;
                  if (selectedClient == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please select a client")),
                    );
                    return;
                  }

                  final budget = double.tryParse(budgetCon.text);
                  if (budget == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Enter a valid budget")),
                    );
                    return;
                  }

                  try {
                    final provider = context.read<ProjectProvider>();
                    final response = await provider.addProject(
                      name: nameCon.text,
                      description: descCon.text,
                      budget: budget,
                      startDate: startDateCon.text,
                      deadline: deadlineCon.text,
                      clientId: selectedClient!,
                    );

                    if (response['status'] == 'success') {
                      if (!mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Project created successfully!"),
                          duration: Duration(seconds: 1),
                        ),
                      );

                      await Future.delayed(const Duration(seconds: 1));
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            response['message'] ?? "Failed to create project",
                          ),
                        ),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Failed to add project: $e")),
                    );
                  }
                },
                child: const Text("Add Project"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
