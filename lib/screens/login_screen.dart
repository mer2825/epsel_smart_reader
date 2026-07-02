import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:connectivity_plus/connectivity_plus.dart'; // Importamos el paquete
import '../services/firebase_service.dart';
import '../models/usuario.dart';

class LoginScreen extends StatefulWidget {
  final Function(String, String) onLoginSuccess;
  const LoginScreen({super.key, required this.onLoginSuccess});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _firebaseService = FirebaseService();

  bool _isLoading = false;
  bool _obscureText = true;

  Future<void> _handleLogin() async {
    setState(() { _isLoading = true; });

    // --- VERIFICACIÓN DE CONEXIÓN A INTERNET ---
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No hay conexión a internet'), backgroundColor: Colors.red),
        );
      }
      setState(() { _isLoading = false; });
      return;
    }
    // --- FIN DE LA VERIFICACIÓN ---

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

    final User? user = await _firebaseService.signInWithEmailAndPassword(email, password);

    if (user != null) {
      final Usuario? usuarioData = await _firebaseService.getUsuarioPorUid(user.uid);

      if (usuarioData != null) {
        widget.onLoginSuccess("${usuarioData.nombres} ${usuarioData.apellidos}", usuarioData.rol);
        
        if (mounted) {
          Navigator.pop(context);
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
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/fondo_agua.jpeg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  padding: const EdgeInsets.all(30.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95), 
                    borderRadius: BorderRadius.circular(40), 
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset("assets/images/logo_epsel.jpeg", height: 140),
                      const SizedBox(height: 10),
                      const Text('Epsel S.A.', 
                        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black)),
                      const SizedBox(height: 30),

                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'Ingrese correo electrónico',
                          prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF005696), size: 30),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                      ),
                      const SizedBox(height: 15),

                      TextField(
                        controller: _passController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          hintText: 'Ingrese contraseña',
                          prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF005696), size: 30),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText ? Icons.visibility_off : Icons.visibility,
                              color: const Color(0xFF005696),
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                      ),

                      const SizedBox(height: 10),

                      _isLoading 
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF7CC8EB), 
                              minimumSize: const Size(double.infinity, 55),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              elevation: 0,
                            ),
                            child: const Text('Iniciar sesión', 
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                          ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
