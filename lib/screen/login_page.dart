import 'package:flutter/material.dart';
import 'package:sistema_peaje/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  final AuthService auth;

  const LoginPage({super.key, required this.auth});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String email = '';
  String password = '';

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
          Positioned.fill(
            child: Image.asset('assets/images/login.png', fit: BoxFit.cover),
          ),
          // Capa semitransparente para mejorar legibilidad
          Container(color: Colors.transparent),

          // Contenido
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(32, 132, 32, 32),
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
                  style: TextStyle(
                    color: Colors.white,
                  ), // Color del texto ingresado
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ), // Color del label
                    hintStyle: TextStyle(color: Colors.white), // Color del hint
                    filled: true,
                    fillColor: const Color.fromRGBO(108, 146, 134, 1),
                    prefixIcon: Icon(Icons.email, color: Colors.white),
                    border: OutlineInputBorder(
                      // Borde normal
                      borderRadius: BorderRadius.circular(60),
                      borderSide: BorderSide.none, // Sin borde visible
                    ),
                    enabledBorder: OutlineInputBorder(
                      // Borde cuando está habilitado
                      borderRadius: BorderRadius.circular(60),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      // Borde cuando está enfocado
                      borderRadius: BorderRadius.circular(60),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 15.0,
                      horizontal: 20.0,
                    ),
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
                  style: TextStyle(
                    color: Colors.white,
                  ), // Color del texto ingresado
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ), // Color del label
                    hintStyle: TextStyle(color: Colors.white), // Color del hint
                    filled: true,
                    fillColor: const Color.fromRGBO(108, 146, 134, 1),
                    prefixIcon: Icon(Icons.key, color: Colors.white),
                    border: OutlineInputBorder(
                      // Borde normal
                      borderRadius: BorderRadius.circular(60),
                      borderSide: BorderSide.none, // Sin borde visible
                    ),
                    enabledBorder: OutlineInputBorder(
                      // Borde cuando está habilitado
                      borderRadius: BorderRadius.circular(60),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      // Borde cuando está enfocado
                      borderRadius: BorderRadius.circular(60),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 15.0,
                      horizontal: 20.0,
                    ),
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
                        await widget.auth.login(email, password);
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
