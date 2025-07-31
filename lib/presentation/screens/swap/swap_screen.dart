import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/stellar/stellar_cubit.dart';
import '../../widgets/auth/custom_text_field.dart';
import '../../widgets/action_button.dart';
import 'dart:async';

class SwapScreen extends StatefulWidget {
  @override
  _SwapScreenState createState() => _SwapScreenState();
}

class _SwapScreenState extends State<SwapScreen> {
  final _xlmController = TextEditingController();
  double _estimatedUSDC = 0.0;
  double? _currentRate;
  Timer? _rateUpdateTimer;

  @override
  void initState() {
    super.initState();
    _fetchCurrentRate();
    // Update rate every 30 seconds
    _rateUpdateTimer =
        Timer.periodic(Duration(seconds: 30), (_) => _fetchCurrentRate());
  }

  Future<void> _fetchCurrentRate() async {
    try {
      final rate = await context.read<StellarCubit>().getRate();
      setState(() {
        _currentRate = rate;
        _calculateEstimatedUSDC(_xlmController.text);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch current rate: $e')),
      );
    }
  }

  void _calculateEstimatedUSDC(String xlmAmount) {
    print('xlmAmount: $xlmAmount');
    if (xlmAmount.isEmpty || _currentRate == null) {
      setState(() => _estimatedUSDC = 0.0);
      return;
    }
    try {
      final xlm = double.parse(xlmAmount);
      setState(() => _estimatedUSDC = xlm * _currentRate!);
      print('estimatedUSDC: $_estimatedUSDC');
    } catch (e) {
      setState(() => _estimatedUSDC = 0.0);
    }
  }

  Future<bool?> _showConfirmationDialog() async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Swap'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('You are about to swap:'),
            SizedBox(height: 8),
            Text('${_xlmController.text} XLM'),
            Text('≈ $_estimatedUSDC USDC'),
            SizedBox(height: 16),
            Text('Do you want to proceed?'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Confirm'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Swap XLM to USDC'),
      ),
      body: BlocConsumer<StellarCubit, StellarState>(
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Swap failed: ${state.error}')),
            );
          } else if (!state.isLoading &&
              state.error == null &&
              state.usdcBalance != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Swap completed successfully!')),
            );
            Navigator.pop(context); // Return to home screen
          }
        },
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomTextField(
                  controller: _xlmController,
                  label: 'XLM Amount',
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onTextChanged: _calculateEstimatedUSDC,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Please enter an amount';
                    if (double.tryParse(value) == null)
                      return 'Please enter a valid number';
                    return null;
                  },
                ),
                SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Estimated USDC',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(height: 8),
                        Text(
                          '$_estimatedUSDC USDC',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              'Current Rate: ${_currentRate != null ? '1 USDC = ${_currentRate!.toStringAsFixed(6)} XLM' : 'Loading...'}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            IconButton(
                              icon: Icon(Icons.refresh),
                              onPressed: _fetchCurrentRate,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                if (state.isLoading)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                Spacer(),
                ActionButton(
                  icon: Icons.swap_horiz,
                  label: 'Swap Now',
                  onTap: () {
                    if (state.isLoading) return;
                    if (_xlmController.text.isEmpty) return;
                    _showConfirmationDialog().then((confirmed) {
                      if (confirmed == true) {
                        final xlmAmount = double.parse(_xlmController.text);
                        context.read<StellarCubit>().swapXLMToUSDC(
                              xlmAmount: xlmAmount,
                              expectedUsdcAmount: _estimatedUSDC,
                            );
                      }
                    });
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _rateUpdateTimer?.cancel();
    _xlmController.dispose();
    super.dispose();
  }
}
