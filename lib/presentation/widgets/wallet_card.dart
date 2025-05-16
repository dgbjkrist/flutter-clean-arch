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
        padding: EdgeInsets.all(16),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Public Key: ${_formatAddress(account.publicKey)}',
              style: TextStyle(color: Colors.white70),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _BalanceItem(
                  label: 'XLM Balance',
                  amount: account.balance,
                  symbol: 'XLM',
                ),
                if (usdcBalance != null)
                  _BalanceItem(
                    label: 'USDC Balance',
                    amount: usdcBalance!,
                    symbol: 'USDC',
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatAddress(String address) {
    if (address.length < 12) return address;
    return '${address.substring(0, 6)}...${address.substring(address.length - 6)}';
  }
}

class _BalanceItem extends StatelessWidget {
  final String label;
  final double amount;
  final String symbol;

  const _BalanceItem({
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
          style: TextStyle(color: Colors.white70, fontSize: 12),
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
