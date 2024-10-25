import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email')),
            TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true),
            const SizedBox(height: 16),
            if (isLoading)
              const CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: _register,
                child: const Text('Register'),
              ),
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Sudah punya akun? Login'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _register() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      await ref
          .read(authProvider.notifier)
          .register(emailController.text, passwordController.text);
      Navigator.pop(
          context); // Kembali ke layar login setelah berhasil mendaftar
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
