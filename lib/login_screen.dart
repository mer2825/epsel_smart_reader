import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  final Function(String) onLoginSuccess;
  const LoginScreen({super.key, required this.onLoginSuccess});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  bool _isLoading = false;
  bool _obscureText = true; // Controla si se ve la clave o no

  Future<void> _handleLogin() async {
    setState(() { _isLoading = true; });
    try {
      final String response = await rootBundle.loadString('assets/usuarios.json');
      final data = await json.decode(response);
      final List users = data['usuarios'];

      bool encontrado = false;
      String nombreTecnico = "";

      for (var user in users) {
        if (user['correo'] == _emailController.text.trim() && 
            user['pass'] == _passController.text.trim()) {
          encontrado = true;
          nombreTecnico = user['nombre'];
          break;
        }
      }

      await Future.delayed(const Duration(milliseconds: 500));

      if (encontrado) {
        widget.onLoginSuccess(nombreTecnico);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Credenciales incorrectas'), backgroundColor: Colors.red),
          );
        }
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      if (mounted) setState(() { _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. FONDO DE AGUA (.JPEG)
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

          // 2. CONTENEDOR BLANCO (ESTILO FIGMA)
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
                      // LOGO EPSEL (.JPEG)
                      Image.asset("assets/images/logo_epsel.jpeg", height: 140),
                      const SizedBox(height: 10),
                      const Text('Epsel S.A.', 
                        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black)),
                      const SizedBox(height: 30),

                      // INPUT USUARIO
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: 'Ingrese usuario',
                          prefixIcon: const Icon(Icons.account_circle_outlined, color: Color(0xFF005696), size: 30),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // INPUT PASSWORD CON FUNCIÓN DE VER CONTRASEÑA
                      TextField(
                        controller: _passController,
                        obscureText: _obscureText, // Aplica el estado
                        decoration: InputDecoration(
                          hintText: 'Ingrese contraseña',
                          prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF005696), size: 30),
                          // BOTÓN INTERACTIVO DEL OJO
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

                      // BOTÓN CELESTE FIGMA
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