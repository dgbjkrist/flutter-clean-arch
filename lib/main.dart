import 'package:cleanarchi/presentation/cubits/auth/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/service_locator.dart' as di;
import 'core/navigation/app_router.dart';
import 'presentation/cubits/auth/lock_screen_cubit.dart';
import 'presentation/cubits/balance_cubit.dart';
import 'presentation/cubits/recipients/recipients_bloc.dart';
import 'presentation/cubits/stellar/stellar_cubit.dart';
import 'presentation/cubits/transfer/fees_bloc.dart';
import 'presentation/cubits/transfer/transfer_bloc.dart';
import 'presentation/cubits/transfer_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => di.sl<LockScreenCubit>()),
        BlocProvider(create: (context) => di.sl<TransferCubit>()),
        BlocProvider(create: (context) => di.sl<BalanceCubit>()),
        BlocProvider(
            create: (context) => di.sl<AuthCubit>()..checkAuthStatus()),
        BlocProvider(create: (context) => di.sl<TransferBloc>()),
        BlocProvider(create: (context) => di.sl<FeesBloc>()),
        BlocProvider(create: (context) => di.sl<RecipientsBloc>()),
        BlocProvider(create: (context) => di.sl<StellarCubit>()),
      ],
      child: Builder(
        builder: (context) {
          final router = AppRouter.getRouter(context);
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Mon App',
            routerConfig: router,
            theme: ThemeData(
              useMaterial3: false,
            ),
          );
        },
      ),
    );
  }
}
