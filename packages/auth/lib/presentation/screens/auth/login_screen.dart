import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../cubits/auth_cubit.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Connexion")),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            context.go('/');
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              TextField(
                controller: emailController,
              ),
              TextField(controller: passwordController, obscureText: true),
              if (state is AuthLoading) const CircularProgressIndicator(),
              ElevatedButton(
                onPressed: () {
                  context
                      .read<AuthCubit>()
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
