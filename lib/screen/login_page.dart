import 'package:flutter/material.dart';
import 'package:sistema_peaje/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String email = '';
  String password = '';
  AuthService auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true, // Para que la imagen esté detrás del AppBar
      body: Stack(
        children: [
          // Imagen de fondo
          // Positioned.fill(
          //   child: Image.asset('assets/images/login_bg.jpg', fit: BoxFit.cover),
          // ),
          // Capa semitransparente para mejorar legibilidad
          Container(color: Colors.blue),

          // Contenido
          Padding(
            padding: EdgeInsets.only(top: 48, bottom: 48, left: 32, right: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person, color: Colors.white, size: 90),
                Padding(
                  padding: const EdgeInsets.only(top: 40, bottom: 40),
                  child: Text(
                    "¡Bienvenido!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon((Icons.search)),
                  ),
                  onChanged: (text) {
                    setState(() {
                      email = text;
                    });
                  },
                ),
                SizedBox(height: 20),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon((Icons.key)),
                  ),
                  obscureText: true,
                  onChanged: (text) {
                    setState(() {
                      password = text;
                    });
                  },
                ),
                SizedBox(height: 60),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    child: Text(
                      'Iniciar secion',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onPressed: () async {
                      if (email.isNotEmpty && password.isNotEmpty) {
                        await auth.login(email, password);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
