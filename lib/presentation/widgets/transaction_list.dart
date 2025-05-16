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
        return ListTile(
          leading: _getTransactionIcon(transaction.type),
          title: Text(transaction.type),
          subtitle: Text(
            '${transaction.timestamp.toString().substring(0, 16)}',
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                transaction.amount > 0
                    ? '+${transaction.amount.toStringAsFixed(2)}'
                    : transaction.amount.toStringAsFixed(2),
                style: TextStyle(
                  color: _getAmountColor(transaction.type),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                transaction.assetCode,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        );
      },
    );
  }

  Icon _getTransactionIcon(String type) {
    switch (type) {
      case 'Sent':
        return Icon(Icons.arrow_upward, color: Colors.red);
      case 'Received':
        return Icon(Icons.arrow_downward, color: Colors.green);
      case 'Trustline Added':
        return Icon(Icons.add_circle_outline, color: Colors.blue);
      case 'Account Created':
        return Icon(Icons.account_balance_wallet, color: Colors.green);
      default:
        return Icon(Icons.swap_horiz);
    }
  }

  Color _getAmountColor(String type) {
    switch (type) {
      case 'Sent':
        return Colors.red;
      case 'Received':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
