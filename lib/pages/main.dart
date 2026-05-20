import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/projects.dart';
import '../widgets/project_tile.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String searchQuery = ""; // store the search text

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      Provider.of<ProjectProvider>(context, listen: false).fetchProjects();
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
          child: TextField(
            decoration: InputDecoration(
              hintText: "Search projects...",
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

        const SizedBox(height: 16),

        // Projects Grid
        Expanded(
          child: Consumer<ProjectProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              // Filter projects by search query
              final filteredProjects = provider.projects.where((project) {
                final nameLower = project.name.toLowerCase();
                final clientLower = project.clientId.toString().toLowerCase();
                return nameLower.contains(searchQuery) ||
                    clientLower.contains(searchQuery);
              }).toList();

              if (filteredProjects.isEmpty) {
                return const Center(
                  child: Text("No projects found"),
                );
              }

              return GridView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: filteredProjects.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.80,
                ),
                itemBuilder: (context, index) {
                  final project = filteredProjects[index];

                  return ProjectTile(
                    id: project.id,
                    date: project.startDate.toString().split(' ')[0],
                    title: project.name,
                    client: "Client ID: ${project.clientId}",
                    progress: project.progress / 100,
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