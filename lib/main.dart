import 'package:flutter/material.dart';
import 'package:proapp/provider/client.dart';
import './provider/user.dart';
import 'package:provider/provider.dart';
import './pages/login.dart';
import './theme.dart';
import 'pages/home.dart';
import './provider/projects.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authProvider = AuthProvider();
  await authProvider.loadUserFromPrefs();

  runApp(
     MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProjectProvider()),
        ChangeNotifierProvider(create: (_) => ClientProvider(),),
      ],
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: authProvider.isLoggedIn ? const HomePage() : const LoginPage(),
    );
  }
}
