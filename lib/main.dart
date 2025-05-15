import 'package:cleanarchi/presentation/cubits/auth/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/service_locator.dart';
import 'core/navigation/app_router.dart';
import 'presentation/cubits/balance_cubit.dart';
import 'presentation/cubits/recipients/recipients_bloc.dart';
import 'presentation/cubits/stellar/stellar_cubit.dart';
import 'presentation/cubits/transfer/fees_bloc.dart';
import 'presentation/cubits/transfer/transfer_bloc.dart';
import 'presentation/cubits/transfer_cubit.dart';

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
        BlocProvider(create: (context) => sl<AuthCubit>()),
        BlocProvider(create: (context) => sl<TransferBloc>()),
        BlocProvider(create: (context) => sl<FeesBloc>()),
        BlocProvider(create: (context) => sl<RecipientsBloc>()),
        BlocProvider(create: (context) => sl<StellarCubit>()),
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
