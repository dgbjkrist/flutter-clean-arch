import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/session/session_manager.dart';
import '../../cubits/auth/lock_screen_cubit.dart';
import '../../widgets/auth/custom_button.dart';
import '../../widgets/auth/custom_text_field.dart';

class LockScreen extends StatefulWidget {
  @override
  _LockScreenState createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: BlocConsumer<LockScreenCubit, LockScreenState>(
          listener: (context, state) {
            if (state is LockScreenError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(
                      Icons.lock_outline,
                      size: 80,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Screen Locked',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Enter your password to unlock',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.grey,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    CustomTextField(
                      label: 'Password',
                      controller: _passwordController,
                      isPassword: true,
                      prefixIcon: Icons.lock_outline,
                    ),
                    const SizedBox(height: 24),
                    CustomButton(
                      text: 'Unlock',
                      isLoading: state is LockScreenLoading,
                      onPressed: _unlock,
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

  void _unlock() async {
    final password = _passwordController.text;
    if (password.isEmpty) return;

    final isValid =
        await context.read<LockScreenCubit>().verifyPassword(password);
    if (isValid) {
      Navigator.of(context).pop();
      SessionManager().resetTimer();
    } else {
      _passwordController.clear();
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }
}
