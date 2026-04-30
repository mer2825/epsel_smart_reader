import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'login_jefe_screen.dart';

class SelectionScreen extends StatelessWidget {
  final Function(String, String) onLogin; // Para pasar nombre y rol al main

  const SelectionScreen({super.key, required this.onLogin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF005696), Color(0xFF002B49)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // LOGO
            Image.asset('assets/images/logo_epsel.jpeg', height: 120),
            const SizedBox(height: 50),
            const Text(
              "SISTEMA DE GESTIÓN",
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1.5),
            ),
            const SizedBox(height: 10),
            const Text("Seleccione su rol para ingresar", style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 60),

            // BOTÓN TRABAJADOR
            _buildRoleButton(
              context,
              label: "PERSONAL TÉCNICO",
              icon: Icons.engineering,
              color: Colors.white,
              textColor: const Color(0xFF005696),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen(onLoginSuccess: (nombre) => onLogin(nombre, "trabajador"))),
              ),
            ),

            const SizedBox(height: 20),

            // BOTÓN JEFE
            _buildRoleButton(
              context,
              label: "JEFATURA DE ZONA",
              icon: Icons.admin_panel_settings,
              color: const Color(0xFFFFD700), // Dorado
              textColor: const Color(0xFF002B49),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginJefeScreen(onLoginSuccess: (nombre) => onLogin(nombre, "jefe"))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleButton(BuildContext context, {
    required String label,
    required IconData icon,
    required Color color,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: 280,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: textColor),
        label: Text(label, style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 5,
        ),
      ),
    );
  }
}