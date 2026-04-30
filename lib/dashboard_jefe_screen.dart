import 'package:flutter/material.dart';

class DashboardJefeScreen extends StatelessWidget {
  final VoidCallback onLogout;

  const DashboardJefeScreen({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF002B49), // Azul más oscuro para el jefe
        title: const Text('PANEL DE CONTROL - EPSEL', 
          style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.power_settings_new, color: Colors.white),
            onPressed: onLogout,
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Resumen de Hoy", 
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF002B49))),
            const SizedBox(height: 20),

            // TARJETAS DE ESTADÍSTICAS
            Row(
              children: [
                _buildStatCard("Lecturas", "1,240", Colors.blue, Icons.speed),
                const SizedBox(width: 15),
                _buildStatCard("Alertas", "12", Colors.red, Icons.warning_amber),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                _buildStatCard("Técnicos", "45", Colors.green, Icons.people),
                const SizedBox(width: 15),
                _buildStatCard("Avance", "65%", Colors.orange, Icons.trending_up),
              ],
            ),

            const SizedBox(height: 30),
            const Text("Personal en Campo", 
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),

            // LISTA DE TÉCNICOS ACTIVOS
            _buildWorkerTile("Delgado Ramos, Brayan", "Zona Norte", "Activo", Colors.green),
            _buildWorkerTile("García Pérez, Juan", "Zona Sur", "En Pausa", Colors.orange),
            _buildWorkerTile("Torres Luna, María", "Distrito Centro", "Finalizado", Colors.blue),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 10),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkerTile(String name, String zone, String status, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: color.withOpacity(0.1), 
            child: Icon(Icons.person, color: color)),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(zone, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
            child: Text(status, style: const TextStyle(color: Colors.white, fontSize: 10)),
          )
        ],
      ),
    );
  }
}