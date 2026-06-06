import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'toma_lectura_screen.dart'; // IMPORTANTE: Importar la nueva pantalla

class HistorialLecturaScreen extends StatelessWidget {
  final CameraDescription camera;
  const HistorialLecturaScreen({super.key, required this.camera});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: const Color(0xFF005696),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'HISTORIAL DE TOMAS DE LECTURAS',
          style: TextStyle(
            color: Colors.white, 
            fontSize: 13, 
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // SECCIÓN DEL SUMINISTRO (EL CUADRO CELESTE)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.blue.withOpacity(0.1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Suministro:', 
                      style: TextStyle(color: Colors.black54, fontSize: 13)
                    ),
                    SizedBox(height: 5),
                    Text(
                      '34546785',
                      style: TextStyle(
                        color: Color(0xFF005696), 
                        fontSize: 24, 
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
                // BOTÓN AGREGAR LECTURA - AHORA REDIRIGE A LA HOJA DE TOMA
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TomaLecturaScreen(
                          camera: camera, 
                          suministro: '34546785',
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF005696),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Agregar Lectura', 
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)
                  ),
                ),
              ],
            ),
          ),

          // TABLA DE LECTURAS (CONTENEDOR BLANCO)
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05), 
                    blurRadius: 15, 
                    offset: const Offset(0, -5)
                  )
                ],
              ),
              child: Column(
                children: [
                  // CABECERA DE LA TABLA
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25, 25, 25, 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('Fecha', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 13)),
                        Text('Hora', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 13)),
                        Text('Lectura', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 13)),
                      ],
                    ),
                  ),
                  const Divider(height: 1, indent: 20, endIndent: 20),
                  
                  // LISTA DE DATOS DINÁMICA
                  Expanded(
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        _buildDataRow("20/09/2024", "10:30 AM", "456 m³"),
                        _buildDataRow("21/09/2024", "09:15 AM", "460 m³"),
                        _buildDataRow("22/09/2024", "11:00 AM", "468 m³"),
                        _buildDataRow("23/09/2024", "08:45 AM", "475 m³"),
                        _buildDataRow("24/09/2024", "04:20 PM", "482 m³"),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataRow(String fecha, String hora, String lectura) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF8F8F8))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            fecha, 
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black87)
          ),
          Text(
            hora, 
            style: const TextStyle(color: Colors.grey, fontSize: 13)
          ),
          Text(
            lectura, 
            style: const TextStyle(
              fontWeight: FontWeight.bold, 
              color: Color(0xFF005696), 
              fontSize: 15
            )
          ),
        ],
      ),
    );
  }
}