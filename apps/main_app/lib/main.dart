import 'package:cleanarchi/presentation/blocs/auth/auth_bloc.dart';
import 'package:cleanarchi/presentation/blocs/balance_cubit.dart';
import 'package:cleanarchi/presentation/blocs/transfer/transfer_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/service_locator.dart';
import 'core/navigation/app_router.dart';
import 'presentation/blocs/recipients/recipients_bloc.dart';
import 'presentation/blocs/transfer/fees_bloc.dart';
import 'presentation/blocs/transfer_cubit.dart';

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
        BlocProvider(create: (context) => sl<TransferCubit>()),
        BlocProvider(create: (context) => sl<BalanceCubit>()),
        BlocProvider(create: (context) => sl<AuthBloc>()),
        BlocProvider(create: (context) => sl<TransferBloc>()),
        BlocProvider(create: (context) => sl<FeesBloc>()),
        BlocProvider(create: (context) => sl<RecipientsBloc>()),
      ],
      child: Builder(
        builder: (context) {
          final router = AppRouter.getRouter(context);
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Mon App',
            routerConfig: router,
          );
        },
      ),
      // child: MaterialApp(
      //   title: 'Flutter Demo clean archi',
      //   home: LoginScreen(),
      // ),
    );
  }
}
