import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proapp/widgets/dashboardCard.dart';
import 'package:proapp/pages/pro_detail.dart';
import 'package:proapp/provider/user.dart';
import 'package:proapp/provider/projects.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }
  final formatter = NumberFormat('#,##0');
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProjectProvider>().fetchDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<AuthProvider>(context);
    final user = userProvider.user;

    return Consumer<ProjectProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              const SizedBox(height: 36),

              // Greeting
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Hi, ${user!.name}!",
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 25),
                    ),
                    Text(
                      'Good Evening',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 18),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              GridView.count(
                crossAxisCount: 2, // 2 cards per row
                shrinkWrap: true, // so it fits in Column
                physics:
                    NeverScrollableScrollPhysics(), // disable scrolling inside parent scroll
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                childAspectRatio: 1.5, // width / height ratio, adjust as needed
                children: [
                  DashboardCard(
                    title: "Revenue",
                    value: "PKR ${formatter.format(provider.revenue)}",
                    icon: Icons.attach_money,
                    color: Colors.green,
                  ),
                  DashboardCard(
                    title: "Receivables",
                    value: "PKR ${formatter.format(provider.receivables)}",
                    icon: Icons.money_off,
                    color: Colors.amber,
                  ),
                  DashboardCard(
                    title: "Upcoming Projects",
                    value: provider.totalUpcoming.toString(),
                    icon: Icons.warning,
                    color: Colors.red,
                  ),
                  DashboardCard(
                    title: "Pending tasks", 
                    value: provider.tasksPen.toString(), 
                    icon: Icons.task_alt, 
                    color: Colors.blue)
                  // You can add more cards here if needed
                ],
              ),
              SizedBox(height: 20),
              Divider(thickness: 2,color: Theme.of(context).primaryColor,),
              SizedBox(height: 20),
              Expanded(
                child: provider.upcomingProjects.isEmpty
                ? Text("You have no upcoming projects", 
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 18),) :
                 ListView.builder(
                  itemCount: provider.upcomingProjects.length,
                  itemBuilder: (context, index) {
                    final project = provider.upcomingProjects[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary
                            .withOpacity(0.3), // theme background
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).colorScheme.secondary.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        title: Text(
                          project.name,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          "Deadline: ${formatDate(project.deadline)}",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Theme.of(context).colorScheme.primary,
                          size: 18,
                        ),
                        onTap: () {
                          // Navigate to another page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProjectDetailPage(projectId: project.id),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
