import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'providers/auth_provider.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);

    return MaterialApp(
      title: 'Flutter Appwrite Auth',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: user == null ? const LoginScreen() : const HomeScreen(),
    );
  }
}
