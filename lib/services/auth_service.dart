class AuthService {
  bool isLoggedIn = false;
  
  Future<bool> login(String email, String password) async {
    // Aquí iría tu lógica de autenticación real
    if (email.isNotEmpty && password.isNotEmpty) {
      isLoggedIn = true;
      return true;
    }
    return false;
  }
  
  void logout() {
    isLoggedIn = false;
  }
}