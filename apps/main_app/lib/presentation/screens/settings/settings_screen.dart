import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../blocs/auth/auth_bloc.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Réglages")),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthUnauthenticated) {
            Navigator.of(context).pop(); // Masquer le loader
            context.go('/login'); // Rediriger vers l'écran de connexion
          }
          if (state is AuthLoading) {
            _showOverlayLoader(context); // Afficher le loader
          }
        },
        builder: (context, state) {
          return Center(
            child: ElevatedButton(
              onPressed: () {
                context.read<AuthBloc>().logout();
              },
              child: Text("Se déconnecter"),
            ),
          );
        },
      ),
    );
  }

  void _showOverlayLoader(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => WillPopScope(
        onWillPop: () async =>
            false, // Empêcher la fermeture du loader avec retour
        child: Center(
          child: CircularProgressIndicator(), // Loader global
        ),
      ),
    );
  }
}
