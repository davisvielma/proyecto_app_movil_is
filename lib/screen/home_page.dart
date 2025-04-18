import 'package:flutter/material.dart';
import 'package:sistema_peaje/services/auth_service.dart';
import 'package:sistema_peaje/screen/login_page.dart';

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
              onPressed: () {
                auth.logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        ),
        body: Center(child: Text('Bienvenido!')),
      ),
    );
  }
}