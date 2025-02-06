import 'package:flutter/material.dart';
import 'package:hamayesh_negar_android/services/api_client.dart';
import 'package:hamayesh_negar_android/services/auth_service.dart';
import 'package:hamayesh_negar_android/services/storage_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/network_service.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final apiClient = ApiClient();
  final storage = StorageService(prefs);
  final authService = AuthService(apiClient, storage);

  // await authService.tryAutoLogin();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>.value(value: authService),
        Provider<StorageService>.value(
          value: storage,
        ),
        ChangeNotifierProvider(create: (_) => NetworkService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hamayesh Negar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
