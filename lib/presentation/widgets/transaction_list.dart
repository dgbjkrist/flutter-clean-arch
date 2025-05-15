import 'package:flutter/material.dart';
import '../../domain/entities/transaction_history.dart';
import 'package:timeago/timeago.dart' as timeago;

class TransactionList extends StatelessWidget {
  final List<TransactionHistory> transactions;

  const TransactionList({
    Key? key,
    required this.transactions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return Center(
        child: Text('No transactions yet'),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return TransactionCard(transaction: transaction);
      },
    );
  }
}

class TransactionCard extends StatelessWidget {
  final TransactionHistory transaction;

  const TransactionCard({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getTransactionColor(),
          child: Icon(
            _getTransactionIcon(),
            color: Colors.white,
          ),
        ),
        title: Text(transaction.type),
        subtitle: Text(
          '${_formatAddress(transaction.from)} → ${_formatAddress(transaction.to)}',
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${transaction.amount} ${transaction.assetCode}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _getAmountColor(context),
              ),
            ),
            Text(
              timeago.format(transaction.timestamp),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Color _getTransactionColor() {
    switch (transaction.type) {
      case 'XLM Payment':
        return Colors.blue;
      case 'USDC Payment':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getTransactionIcon() {
    switch (transaction.type) {
      case 'XLM Payment':
        return Icons.currency_exchange;
      case 'USDC Payment':
        return Icons.attach_money;
      default:
        return Icons.swap_horiz;
    }
  }

  Color _getAmountColor(BuildContext context) {
    return transaction.from == transaction.to ? Colors.grey : Colors.green;
  }

  String _formatAddress(String address) {
    if (address.length <= 8) return address;
    return '${address.substring(0, 4)}...${address.substring(address.length - 4)}';
  }
}
