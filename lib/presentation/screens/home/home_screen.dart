import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/auth/auth_cubit.dart';
import '../../cubits/stellar/stellar_cubit.dart';
import '../../screens/payment/payment_screen.dart';
import '../../widgets/action_button.dart';
import '../../widgets/transaction_list.dart';
import '../../widgets/wallet_card.dart';
import '../swap/swap_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _loadStellarAccount();
  }

  void _loadStellarAccount() {
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated &&
        authState.user.stellarAccount != null) {
      context.read<StellarCubit>().loadAccountDetails(
            publicKey: authState.user.stellarAccount?.publicKey,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async => _loadStellarAccount(),
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: BlocBuilder<AuthCubit, AuthState>(
              builder: (context, authState) {
                if (authState is! AuthAuthenticated) {
                  return Center(
                      child: Text('Please login to view your account'));
                }

                if (!authState.user.hasStellarAccount) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('No Stellar account found'),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<StellarCubit>().createStellarAccount();
                          },
                          child: Text('Create Stellar Account'),
                        ),
                      ],
                    ),
                  );
                }

                return BlocBuilder<StellarCubit, StellarState>(
                  builder: (context, stellarState) {
                    if (stellarState.isLoading) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text('Loading account details...'),
                          ],
                        ),
                      );
                    }

                    if (stellarState.error != null) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(stellarState.error!),
                            SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _loadStellarAccount,
                              child: Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }

                    if (stellarState.account == null) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Could not load account details'),
                            SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _loadStellarAccount,
                              child: Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }

                    return Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          WalletCard(
                            account: stellarState.account!,
                            usdcBalance: stellarState.usdcBalance,
                          ),
                          SizedBox(height: 16),
                          if (!stellarState.hasTrustline)
                            ElevatedButton(
                              onPressed: () => context
                                  .read<StellarCubit>()
                                  .addUSDCTrustline(
                                      authState.user.stellarAccount!.secretKey),
                              child: Text('Add USDC Support'),
                            ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ActionButton(
                                icon: Icons.swap_horiz,
                                label: 'Swap',
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SwapScreen()),
                                ),
                              ),
                              ActionButton(
                                icon: Icons.send,
                                label: 'Transfer',
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PaymentScreen(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (stellarState.transactions?.isNotEmpty ??
                              false) ...[
                            SizedBox(height: 24),
                            Text(
                              'Recent Transactions',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            SizedBox(height: 8),
                            TransactionList(
                              transactions: stellarState.transactions!,
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
