import 'dart:async';

class AuthService {
  bool _isLoggedIn = false;
  final StreamController<bool> _authStreamController =
      StreamController<bool>.broadcast();

  Stream<bool> get authStateChanges => _authStreamController.stream;
  bool get isLoggedIn => _isLoggedIn;

  Future<void> login(String email, String password) async {
    if (email.isNotEmpty && password.isNotEmpty) {
      _isLoggedIn = true;
      _authStreamController.add(true);
    }
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _authStreamController.add(false);
  }

  // Cierra el StreamController cuando ya no se use
  void dispose() {
    _authStreamController.close();
  }
}
