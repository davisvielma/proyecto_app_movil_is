import 'package:flutter/material.dart';
import 'package:sistema_peaje/services/auth_service.dart';

class HomePage extends StatelessWidget {
  final AuthService auth;

  const HomePage({super.key, required this.auth});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Bloquea el botón de retroceso
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home'),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async  {
                await auth.logout();
              },
            ),
          ],
        ),
        body: Center(child: Text('Bienvenido!')),
      ),
    );
  }
}