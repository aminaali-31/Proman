import 'package:flutter/material.dart';
import 'package:proapp/provider/projects.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProjectProvider>(context);

    // Fetch profile when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (profileProvider.profile == null && !profileProvider.isLoading) {
        profileProvider.fetchProfile();
      }
    });

    return profileProvider.isLoading
        ? const Center(child: CircularProgressIndicator())
        : profileProvider.error != null
        ? Center(
            child: Text(
              profileProvider.error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          )
        : profileProvider.profile == null
        ? const Center(child: Text("No profile found"))
        : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: SingleChildScrollView(
              child: Column(
                children: [
                  /// PROFILE HEADER CARD
                  SizedBox(height: 28,),
                  Card(
                    color: Theme.of(context).cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 6,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Row(
                        children: [
                          /// Avatar
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            child: Text(
                              profileProvider.profile!.name[0].toUpperCase(),
                              style: const TextStyle(
                                fontSize: 32,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
          
                          const SizedBox(width: 16),
          
                          /// Name + Role
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                profileProvider.profile!.name,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                profileProvider.profile!.role,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
          
                  const SizedBox(height: 20),
          
                  /// STATS CARDS ROW
                  Row(
                    children: [
                      /// Total Projects Card
                      Expanded(
                        child: _statCard(
                          title: "Projects",
                          value: "${profileProvider.profile!.projects}", // Replace with dynamic value
                          icon: Icons.work,
                          context: context,
                        ),
                      ),
          
                      const SizedBox(width: 12),
          
                      /// Another Stat (optional)
                      Expanded(
                        child: _statCard(
                          title: "Completed",
                          value: "${profileProvider.profile!.completed}",
                          icon: Icons.check_circle,
                          context: context,
                        ),
                      ),
                    ],
                  ),
          
                  const SizedBox(height: 20),
          
                  /// DETAILS CARD
                  Card(
                    color: Theme.of(context).cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 6,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          _infoTile(
                            icon: Icons.email,
                            label: "Email",
                            value: profileProvider.profile!.email,
                          ),
          
                          const Divider(color: Color.fromARGB(255, 164, 164, 164),),
          
                          _infoTile(
                            icon: Icons.phone,
                            label: "Phone",
                            value: profileProvider.profile!.phone,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        );
  }
}
Widget _statCard({
  required String title,
  required String value,
  required IconData icon,
  required BuildContext context,
}) {
  return Card(
    color: Theme.of(context).cardColor,
    elevation: 5,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
    ),
    child: Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          Icon(
            icon,
            size: 30,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: const Color.fromARGB(255, 164, 164, 164),
            ),
          ),
        ],
      ),
    ),
  );
}
Widget _infoTile({
  required IconData icon,
  required String label,
  required String value,
}) {
  return Row(
    children: [
      Icon(icon),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Color.fromARGB(255, 164, 164, 164),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}