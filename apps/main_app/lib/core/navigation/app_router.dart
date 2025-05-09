import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/main_screen.dart';
import '../../presentation/blocs/auth/auth_bloc.dart';

class AppRouter {
  static GoRouter getRouter(BuildContext context) {
    return GoRouter(
      initialLocation: '/', // Démarre sur l'écran principal
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const MainScreen(),
        ),
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
        final authState = context.read<AuthBloc>().state;

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
