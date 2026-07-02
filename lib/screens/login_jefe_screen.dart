import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_service.dart';
import '../models/usuario.dart';

class LoginJefeScreen extends StatefulWidget {
  final Function(String, String) onLoginSuccess;
  const LoginJefeScreen({super.key, required this.onLoginSuccess});

  @override
  State<LoginJefeScreen> createState() => _LoginJefeScreenState();
}

class _LoginJefeScreenState extends State<LoginJefeScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final FirebaseService _firebaseService = FirebaseService();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    setState(() { _isLoading = true; });

    final email = _emailController.text.trim();
    final password = _passController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, ingrese correo y contraseña'), backgroundColor: Colors.orange),
        );
      }
      setState(() { _isLoading = false; });
      return;
    }

    // --- LÓGICA REAL DE FIREBASE AUTH ---
    final User? user = await _firebaseService.signInWithEmailAndPassword(email, password);

    if (user != null) {
      final Usuario? usuarioData = await _firebaseService.getUsuarioPorUid(user.uid);

      if (usuarioData != null) {
        // VERIFICAMOS QUE EL ROL SEA 'JEFE'
        if (usuarioData.rol == 'jefe') {
          widget.onLoginSuccess("${usuarioData.nombres} ${usuarioData.apellidos}", usuarioData.rol);
        } else {
          // Si el usuario no es jefe, mostramos error y cerramos sesión
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Acceso denegado. No tienes rol de Jefe.'), backgroundColor: Colors.red),
            );
          }
          await _firebaseService.signOut();
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error: Datos de usuario no encontrados'), backgroundColor: Colors.red),
          );
        }
        await _firebaseService.signOut();
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Correo o contraseña incorrectos'), backgroundColor: Colors.red),
        );
      }
    }

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
                  _buildAdminField(_emailController, 'Correo electrónico', Icons.email_outlined),
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
      keyboardType: isPass ? TextInputType.visiblePassword : TextInputType.emailAddress,
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
