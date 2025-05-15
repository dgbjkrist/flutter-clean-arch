import 'package:flutter/material.dart';
import '../../domain/entities/stellar_account.dart';

class WalletCard extends StatelessWidget {
  final StellarAccount account;
  final double? usdcBalance;

  const WalletCard({
    Key? key,
    required this.account,
    this.usdcBalance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade700,
              Colors.blue.shade900,
            ],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Stellar Wallet',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    Icons.account_balance_wallet,
                    color: Colors.white,
                    size: 32,
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Account ID',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 4),
              Text(
                _formatAccountId(account.publicKey),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'monospace',
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _BalanceDisplay(
                    label: 'XLM Balance',
                    amount: account.balance,
                    symbol: 'XLM',
                  ),
                  if (usdcBalance != null)
                    _BalanceDisplay(
                      label: 'USDC Balance',
                      amount: usdcBalance!,
                      symbol: 'USDC',
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatAccountId(String id) {
    if (id.length <= 12) return id;
    return '${id.substring(0, 6)}...${id.substring(id.length - 6)}';
  }
}

class _BalanceDisplay extends StatelessWidget {
  final String label;
  final double amount;
  final String symbol;

  const _BalanceDisplay({
    required this.label,
    required this.amount,
    required this.symbol,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 4),
        Text(
          '$amount $symbol',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
