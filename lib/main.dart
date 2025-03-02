import 'package:cleanarchi/presentation/blocs/auth/auth_bloc.dart';
import 'package:cleanarchi/presentation/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di.dart';

void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AuthBloc>()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo clean archi',
        home: LoginScreen(),
      ),
    );
  }
}
