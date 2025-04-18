import 'package:flutter/material.dart';
import 'package:sistema_peaje/services/auth_service.dart';
import 'package:sistema_peaje/screen/home_page.dart';
import 'package:sistema_peaje/screen/login_page.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  final AuthService auth = AuthService();

  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FutureBuilder(
        future: Future.delayed(Duration.zero, () => auth.isLoggedIn),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return snapshot.data == true ? HomePage(auth: auth) : LoginPage();
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
// .