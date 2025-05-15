import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/stellar/stellar_cubit.dart';
import '../../screens/payment/payment_screen.dart';
import '../../widgets/action_button.dart';
import '../../widgets/swap_bottom_sheet.dart';
import '../../widgets/transaction_list.dart';
import '../../widgets/wallet_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<StellarCubit>().loadAccountDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => context.read<StellarCubit>().loadAccountDetails(),
        child: BlocBuilder<StellarCubit, StellarState>(
          builder: (context, state) {
            if (state.isLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (state.error != null) {
              return Center(child: Text(state.error!));
            }

            if (state.account == null) {
              return Center(child: Text('No account found'));
            }

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    WalletCard(
                      account: state.account!,
                      usdcBalance: state.usdcBalance,
                    ),
                    SizedBox(height: 16),
                    if (!state.hasTrustline)
                      ElevatedButton(
                        onPressed: () =>
                            context.read<StellarCubit>().addUSDCTrustline(),
                        child: Text('Add USDC Support'),
                      ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ActionButton(
                          icon: Icons.swap_horiz,
                          label: 'Swap',
                          onTap: () => _showSwapDialog(context),
                        ),
                        ActionButton(
                          icon: Icons.send,
                          label: 'Transfer',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PaymentScreen()),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Recent Transactions',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 8),
                    TransactionList(
                      transactions: state.transactions ?? [],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showSwapDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SwapBottomSheet(),
    );
  }
}
