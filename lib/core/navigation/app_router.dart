import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/register_screen.dart';
import '../../presentation/screens/auth/registration_screen.dart';
import '../../presentation/screens/lock/lock_screen.dart';
import '../../presentation/screens/main_screen.dart';
import '../../presentation/cubits/auth/auth_cubit.dart';

class AppRouter {
  static GoRouter getRouter(BuildContext context) {
    return GoRouter(
      initialLocation: '/',
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
          path: '/register',
          builder: (context, state) => RegisterScreen(),
        ),
        GoRoute(
          path: '/lock',
          builder: (context, state) => LockScreen(),
        ),
      ],
      redirect: (context, state) {
        final authState = context.read<AuthCubit>().state;

        if (authState is AuthAuthenticated) {
          if (state.matchedLocation == '/login' ||
              state.matchedLocation == '/register') {
            return '/';
          }
        } else {
          if (state.matchedLocation != '/login' &&
              state.matchedLocation != '/register') {
            return '/login';
          }
        }
        return null;
      },
    );
  }
}
