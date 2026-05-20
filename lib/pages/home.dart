import 'package:flutter/material.dart';
import 'package:proapp/pages/dashboard.dart';
import 'package:proapp/pages/profile.dart';
import '../theme.dart'; // Make sure this imports your AppTheme
import './main.dart';
import '../pages/add_pro.dart';
import '../pages/addClient.dart';
import '../pages/tasks.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // Example pages for each bottom nav item
  static const List<Widget> _pages = <Widget>[
    Dashboard(),
    Home(),
    TasksList(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.secondaryColor..withValues(alpha: 0.7),
        title: const Text("Project Manager"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddClient()),
              );
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex], // your pages
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        onPressed: () {
          // Navigate to AddProject form
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddProject()),
          );
        },
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, size: 32),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.7),
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: SizedBox(
          height: 60, // Fixed height prevents tiny overflow
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Left items
              IconButton(
                icon: Icon(
                  Icons.dashboard,
                  color: _selectedIndex == 0
                      ? AppTheme.primaryColor
                      : AppTheme.accentColor,
                ),
                onPressed: () => _onItemTapped(0),
              ),
              IconButton(
                icon: Icon(
                  Icons.work,
                  color: _selectedIndex == 1
                      ? AppTheme.primaryColor
                      : AppTheme.accentColor,
                ),
                onPressed: () => _onItemTapped(1),
              ),

              // Space for FAB
              const SizedBox(width: 48), // width of FAB
              // Right items
              IconButton(
                icon: Icon(
                  Icons.task_alt,
                  color: _selectedIndex == 2
                      ? AppTheme.primaryColor
                      : AppTheme.accentColor,
                ),
                onPressed: () => _onItemTapped(2),
              ),
              IconButton(
                icon: const Icon(Icons.person, color: AppTheme.accentColor),
                onPressed: () => _onItemTapped(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
