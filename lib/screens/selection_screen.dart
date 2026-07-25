import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'reclamaciones_screen.dart';

class SelectionScreen extends StatelessWidget {
  final Function(String, String) onLogin;
  const SelectionScreen({super.key, required this.onLogin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/fondo_agua.jpeg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: const Color(0xFF005696).withOpacity(0.7),
          ),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                Image.asset("assets/images/logo_epsel.jpeg", height: 150),
                const SizedBox(height: 20),
                const Text(
                  'Epsel Smart Reader',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    shadows: [Shadow(blurRadius: 10.0, color: Colors.black)],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),
                const Text(
                  'Bienvenido, inicie sesión para continuar',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 30),
                _buildRoleButton(
                  context,
                  'Iniciar Sesión como Trabajador',
                  Icons.engineering,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen(onLoginSuccess: onLogin)),
                  ),
                ),
                const Spacer(flex: 3),
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ReclamacionesScreen()),
                    );
                  },
                  icon: const Icon(Icons.menu_book, color: Colors.white),
                  label: const Text(
                    'Libro de Reclamaciones',
                    style: TextStyle(color: Colors.white, decoration: TextDecoration.underline),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleButton(BuildContext context, String title, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 28),
      label: Text(title, style: const TextStyle(fontSize: 18)),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(300, 60),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF005696),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}
