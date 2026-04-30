import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'scanner_screen.dart';

class TomaLecturaScreen extends StatefulWidget {
  final CameraDescription camera;
  final String suministro;

  const TomaLecturaScreen({super.key, required this.camera, required this.suministro});

  @override
  State<TomaLecturaScreen> createState() => _TomaLecturaScreenState();
}

class _TomaLecturaScreenState extends State<TomaLecturaScreen> {
  final TextEditingController _lecturaController = TextEditingController();
  
  // CAMBIO CLAVE: Ahora usamos una LISTA para guardar las rutas de las fotos
  List<String> _fotosRutas = []; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF005696),
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: const Color(0xFF005696),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset('assets/images/logo_epsel.jpeg', height: 40),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Text('SISTEMA DE LECTURA\nDE MEDIDORES',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFFF5F9FF),
          borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Banner Suministro...
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.assignment_turned_in, color: Color(0xFF005696)),
                    const SizedBox(width: 10),
                    Text('SUMINISTRO: ${widget.suministro}',
                        style: const TextStyle(color: Color(0xFF005696), fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text('Hoja de toma de lectura', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 25),

              // Campo de lectura...
              const Text('Ingrese lectura manual o por NFC', style: TextStyle(color: Color(0xFF005696), fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              SizedBox(
                width: 280,
                child: TextField(
                  controller: _lecturaController,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF005696), letterSpacing: 2),
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF005696), width: 1),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // SECCIÓN FOTO DE LECTURA
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFB3E5FC), width: 2),
                ),
                child: Column(
                  children: [
                    const Text('Foto de lectura', style: TextStyle(color: Color(0xFF005696), fontWeight: FontWeight.bold)),
                    const SizedBox(height: 15),
                    
                    // FILA DE IMÁGENES DINÁMICA
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Mostramos el espacio 1 (Foto o Vacío)
                        _buildPhotoBox(index: 0),
                        // Mostramos el espacio 2 (Foto o Vacío)
                        _buildPhotoBox(index: 1),
                      ],
                    ),
                    
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Fecha y hora de lectura\n2026-04-28 12:45:00', style: TextStyle(fontSize: 10, color: Colors.blueGrey)),
                        
                        // BOTÓN AGREGAR FOTO (Solo habilitado si hay menos de 2 fotos)
                        ElevatedButton.icon(
                          onPressed: _fotosRutas.length >= 2 
                            ? null // Se deshabilita si ya hay 2 fotos
                            : () async {
                                final result = await Navigator.push(
                                  context, 
                                  MaterialPageRoute(builder: (context) => ScannerScreen(camera: widget.camera))
                                );
                                
                                if (result != null && result is Map) {
                                  setState(() {
                                    _lecturaController.text = result['lectura'];
                                    // AGREGAMOS a la lista en lugar de reemplazar
                                    _fotosRutas.add(result['fotoPath']); 
                                  });
                                }
                              },
                          icon: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                          label: const Text('Agregar foto', style: TextStyle(fontSize: 11, color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF005696),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Botón Guardar...
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  icon: const Icon(Icons.save_outlined, size: 65, color: Color(0xFF005696)),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Lectura guardada exitosamente'), backgroundColor: Colors.green)
                    );
                    Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(height: 100), 
            ],
          ),
        ),
      ),
    );
  }

  // WIDGET MEJORADO CON BOTÓN DE ELIMINAR (LA "X")
  Widget _buildPhotoBox({required int index}) {
    // Verificamos si existe una foto para este índice
    bool existeFoto = _fotosRutas.length > index;

    return Stack(
      children: [
        Container(
          width: 110,
          height: 130,
          decoration: BoxDecoration(
            color: const Color(0xFFE3F2FD),
            borderRadius: BorderRadius.circular(15),
            image: existeFoto 
              ? DecorationImage(image: FileImage(File(_fotosRutas[index])), fit: BoxFit.cover)
              : null,
          ),
          child: !existeFoto 
            ? const Icon(Icons.image, color: Colors.white, size: 50)
            : null,
        ),
        // LA "X" PARA ELIMINAR (Solo aparece si hay foto)
        if (existeFoto)
          Positioned(
            top: 5,
            right: 5,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _fotosRutas.removeAt(index); // Eliminamos la foto específica
                });
              },
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 20),
              ),
            ),
          ),
      ],
    );
  }
}