import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../presentation/cubits/auth_cubit.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/lock_screen.dart';

class AppRouter {
  static GoRouter getRouter(BuildContext context) {
    return GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => LoginScreen(),
        ),
        GoRoute(
          path: '/lock',
          builder: (context, state) => LockScreen(),
        ),
      ],
      redirect: (context, state) {
        final authState = context.read<AuthCubit>().state;

        if (authState is AuthAuthenticated) {
          // Utilisateur connecté, on bloque l'accès à la page de connexion
          if (state.matchedLocation == '/login') return '/';
        } else {
          // Utilisateur non connecté, on le renvoie à la page de login
          if (state.matchedLocation != '/login') return '/login';
        }
        return null;
      },
    );
  }
}
