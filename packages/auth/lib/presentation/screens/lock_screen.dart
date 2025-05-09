import 'package:flutter/material.dart';

import '../../core/session/session_manager.dart';

class LockScreen extends StatelessWidget {
  final TextEditingController _passwordController = TextEditingController();

  void _unlock(BuildContext context) {
    if (_passwordController.text == "1234") {
      Navigator.pop(context);
      SessionManager().resetTimer();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mot de passe incorrect")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Entrez votre mot de passe pour déverrouiller"),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: "Mot de passe"),
              ),
              ElevatedButton(
                onPressed: () => _unlock(context),
                child: Text("Déverrouiller"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
