import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../models/usuario.dart';
import 'control_comercial_screen.dart';
import 'monitoreo_campo_screen.dart';
import 'vista_reclamaciones_screen.dart'; // Importamos la nueva pantalla

class DashboardJefeScreen extends StatefulWidget {
  final VoidCallback onLogout;

  const DashboardJefeScreen({super.key, required this.onLogout});

  @override
  State<DashboardJefeScreen> createState() => _DashboardJefeScreenState();
}

class _DashboardJefeScreenState extends State<DashboardJefeScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  late Future<Map<String, dynamic>> _dashboardDataFuture;

  @override
  void initState() {
    super.initState();
    _dashboardDataFuture = _loadDashboardData();
  }

  Future<Map<String, dynamic>> _loadDashboardData() async {
    final results = await Future.wait([
      _firebaseService.getTrabajadores(),
      _firebaseService.getLecturasCount(),
    ]);
    return {
      'trabajadores': results[0] as List<Usuario>,
      'lecturasCount': results[1] as int,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF002B49),
        title: const Text('PANEL DE CONTROL - EPSEL', 
          style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.power_settings_new, color: Colors.white),
            onPressed: widget.onLogout,
          )
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _dashboardDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Error al cargar los datos"));
          }
          
          final List<Usuario> trabajadores = snapshot.data?['trabajadores'] ?? [];
          final int lecturasCount = snapshot.data?['lecturasCount'] ?? 0;
          final String numeroDeTecnicos = trabajadores.length.toString();
          final String numeroDeLecturas = lecturasCount.toString();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Resumen de Hoy", 
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF002B49))),
                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: _HoverableStatCard(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ControlComercialScreen()),
                          );
                        },
                        label: "Lecturas",
                        value: numeroDeLecturas,
                        color: Colors.blue,
                        icon: Icons.speed,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(child: _buildStatCardContent("Alertas", "12", Colors.red, Icons.warning_amber)),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: _HoverableStatCard(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const MonitoreoCampoScreen()),
                          );
                        },
                        label: "Técnicos",
                        value: numeroDeTecnicos,
                        color: Colors.green,
                        icon: Icons.people,
                      ),
                    ),
                    const SizedBox(width: 15),
                    // --- TARJETA DE RECLAMACIONES ---
                    Expanded(
                      child: _HoverableStatCard(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const VistaReclamacionesScreen()),
                          );
                        },
                        label: "Reclamaciones",
                        value: "N/A", // Podríamos contar las pendientes
                        color: Colors.orange,
                        icon: Icons.menu_book,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),
                const Text("Personal en Campo", 
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),

                if (trabajadores.isEmpty)
                  const Center(child: Text("No hay trabajadores registrados"))
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: trabajadores.length,
                    itemBuilder: (context, index) {
                      final trabajador = trabajadores[index];
                      return _buildWorkerTile(
                        "${trabajador.apellidos}, ${trabajador.nombres}",
                        "DNI: ${trabajador.dni}",
                        "Activo",
                        Colors.green,
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCardContent(String label, String value, Color color, IconData icon) {
    return Container(
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

class _HoverableStatCard extends StatefulWidget {
  final VoidCallback onTap;
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _HoverableStatCard({
    required this.onTap,
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  State<_HoverableStatCard> createState() => _HoverableStatCardState();
}

class _HoverableStatCardState extends State<_HoverableStatCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: _isHovering ? Colors.grey[100] : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: _isHovering ? Colors.black26 : Colors.black12,
                blurRadius: _isHovering ? 10 : 5,
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(widget.icon, color: widget.color, size: 30),
              const SizedBox(height: 10),
              Text(widget.value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Text(widget.label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}
