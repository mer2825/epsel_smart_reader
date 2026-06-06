import 'package:flutter/material.dart';
// import '../services/firebase_service.dart'; // Comentado temporalmente
// import '../models/usuario.dart'; // Comentado temporalmente

class LoginJefeScreen extends StatefulWidget {
  final Function(String, String) onLoginSuccess; // Espera nombre y rol
  const LoginJefeScreen({super.key, required this.onLoginSuccess});

  @override
  State<LoginJefeScreen> createState() => _LoginJefeScreenState();
}

class _LoginJefeScreenState extends State<LoginJefeScreen> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  // final FirebaseService _firebaseService = FirebaseService(); // Comentado temporalmente
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    setState(() { _isLoading = true; });
    
    // --- SIMULACIÓN DE LOGIN DE JEFE ---
    await Future.delayed(const Duration(seconds: 1)); // Simula red

    final dniStr = _userController.text.trim();
    
    if (dniStr == 'admin') {
      widget.onLoginSuccess("Jefe de Zona", "jefe");
      
      // ¡SOLUCIÓN! Cierra la pantalla de login después del éxito.
      if (mounted) {
        Navigator.pop(context);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario incorrecto (Prueba con "admin")'), backgroundColor: Colors.red),
        );
      }
    }
    // --- FIN DE SIMULACIÓN ---

    if (mounted) setState(() { _isLoading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF002B49), Color(0xFF005696)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Color(0xFFFFD700),
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/logo_epsel.jpeg',
                  height: 100, width: 100, fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'ADMINISTRACIÓN',
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 2),
            ),
            const Text('Gestión de Jefatura de Zona', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  _buildAdminField(_userController, 'Usuario (admin)', Icons.admin_panel_settings),
                  const SizedBox(height: 20),
                  _buildAdminField(_passController, 'Contraseña', Icons.lock_outline, isPass: true),
                  const SizedBox(height: 40),
                  _isLoading
                  ? const CircularProgressIndicator(color: Color(0xFFFFD700))
                  : SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFD700),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: const Text('ACCEDER AL DASHBOARD', style: TextStyle(color: Color(0xFF002B49), fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminField(TextEditingController controller, String hint, IconData icon, {bool isPass = false}) {
    return TextField(
      controller: controller,
      obscureText: isPass,
      style: const TextStyle(color: Colors.white),
      keyboardType: isPass ? TextInputType.text : TextInputType.text, // Cambiado para admitir "admin"
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white54),
        prefixIcon: Icon(icon, color: const Color(0xFFFFD700)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.white24)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Color(0xFFFFD700))),
      ),
    );
  }
}
