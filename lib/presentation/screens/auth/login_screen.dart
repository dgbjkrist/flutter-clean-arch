import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../main_screen.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Connexion")),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainScreen()),
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              TextField(controller: emailController),
              TextField(controller: passwordController, obscureText: true),
              if (state is AuthLoading) const CircularProgressIndicator(),
              ElevatedButton(
                onPressed: () {
                  context
                      .read<AuthBloc>()
                      .login(emailController.text, passwordController.text);
                },
                child: const Text("Se connecter"),
              ),
            ],
          );
        },
      ),
    );
  }
}
