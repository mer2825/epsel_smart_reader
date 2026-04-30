import 'package:flutter/material.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: const Color(0xFF005696),
        title: const Text('SISTEMA DE LECTURA DE MEDIDORES', style: TextStyle(color: Colors.white, fontSize: 12)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            const CircleAvatar(radius: 40, backgroundColor: Color(0xFFE3F2FD), child: Icon(Icons.person, size: 50, color: Color(0xFF005696))),
            const SizedBox(height: 10),
            const Text('DELGADO RAMOS, BRAYAN STEVEN', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF005696))),
            const SizedBox(height: 30),
            const Text('Perfil de Trabajador', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _buildInfoField('Código:', 'BS122334'),
            _buildInfoField('Nombres:', 'Brayan Steven'),
            _buildInfoField('Apellidos:', 'Delgado Ramos'),
            _buildInfoField('DNI:', '12345678'),
            _buildInfoField('Email:', 'brayandelgado@gmail.com'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          SizedBox(width: 80, child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF005696)))),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(border: Border.all(color: const Color(0xFF005696)), borderRadius: BorderRadius.circular(10)),
              child: Text(value, style: const TextStyle(color: Color(0xFF005696))),
            ),
          ),
        ],
      ),
    );
  }
}