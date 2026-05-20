import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proapp/provider/projects.dart';
import 'package:proapp/services/api_service.dart';

class AddTask extends StatefulWidget {
  final int id;
  const AddTask({super.key, required this.id});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameCon = TextEditingController();
  TextEditingController descCon = TextEditingController();
  TextEditingController startDateCon = TextEditingController();
  TextEditingController deadlineCon = TextEditingController();
  List<Map<String, dynamic>> emps = [];
  bool isLoadingEmps = true;
  String? selectedEmp;

  @override
  void initState() {
    super.initState();
    _loadEmp();
  }

  Future<void> _loadEmp() async {
    try {
      final fetchedClients = await ProjectService().getEmployess();
      setState(() {
        emps = fetchedClients;
        isLoadingEmps = false;
      });
    } catch (e) {
      setState(() {
        isLoadingEmps = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:  AppBar(title: const Text("Add Task")),
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
                  labelText: "Task Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? "Enter Task name"
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

              isLoadingEmps
                  ? CircularProgressIndicator()
                  : DropdownButtonFormField<String>(
                      initialValue: selectedEmp,
                      items: emps
                          .map(
                            (emp) => DropdownMenuItem(
                              value: emp['id'].toString(), // or 'name'
                              child: Text(emp['name']),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedEmp = value;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: "Select Employee",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null ? "Please select a Employee" : null,
                    ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;
                  if (selectedEmp == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please select a Employee")),
                    );
                    return;
                  }
                  try {
                    final provider = context.read<ProjectProvider>();
                    final response = await provider.TaskAdd(
                      name: nameCon.text,
                      description: descCon.text,
                      startDate: startDateCon.text,
                      deadline: deadlineCon.text,
                      assignedTo:int.parse(selectedEmp!),
                      projectId: widget.id
                    );

                    if (response) {
                      if (!mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Task added successfully!"),
                          duration: Duration(seconds: 1),
                        ),
                      );

                      await Future.delayed(const Duration(seconds: 1));
                      Navigator.pop(context, true);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                          "Failed to add Task",
                          ),
                        ),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Failed to add Task: $e")),
                    );
                  }
                },
                child: const Text("Add Task"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
