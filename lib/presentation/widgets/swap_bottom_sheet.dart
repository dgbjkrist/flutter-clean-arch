import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/stellar/stellar_cubit.dart';

class SwapBottomSheet extends StatefulWidget {
  @override
  _SwapBottomSheetState createState() => _SwapBottomSheetState();
}

class _SwapBottomSheetState extends State<SwapBottomSheet> {
  final _amountController = TextEditingController();
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Swap XLM to USDC',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 16),
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'XLM Amount',
              suffix: Text('XLM'),
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _isProcessing ? null : _handleSwap,
            child: _isProcessing
                ? CircularProgressIndicator(color: Colors.white)
                : Text('Swap to USDC'),
          ),
        ],
      ),
    );
  }

  void _handleSwap() async {
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    setState(() => _isProcessing = true);

    try {
      await context.read<StellarCubit>().swapXLMToUSDC(amount);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() => _isProcessing = false);
    }
  }
}
