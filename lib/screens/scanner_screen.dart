import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../services/firebase_service.dart';

class ScannerScreen extends StatefulWidget {
  final CameraDescription camera;
  final String idRuta;
  final String codigoSuministro;

  const ScannerScreen({
    super.key, 
    required this.camera,
    required this.idRuta,
    required this.codigoSuministro,
  });

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  final FirebaseService _firebaseService = FirebaseService();
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.medium, enableAudio: false);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // --- FUNCIÓN DE GUARDADO SIMULADA ---
  Future<void> _procesarYGuardarLectura(String lectura, String fotoPath) async {
    setState(() { _isProcessing = true; });

    // Simulamos una espera de red
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Lectura guardada con éxito (Simulación)"),
          backgroundColor: Colors.green,
        ),
      );
      // Volvemos a la pantalla anterior
      Navigator.pop(context);
    }
    
    setState(() { _isProcessing = false; });
  }

  void _mostrarResultado(String valor, String pathImagen) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text('Lectura Detectada', 
          style: TextStyle(color: Color(0xFF005696), fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('¿El número es correcto?'),
            const SizedBox(height: 20),
            Text(valor, 
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, letterSpacing: 4)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('REINTENTAR', style: TextStyle(color: Colors.grey))
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF005696),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
            ),
            onPressed: () {
              Navigator.pop(context);
              _procesarYGuardarLectura(valor, pathImagen);
            },
            child: const Text('CONFIRMAR', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escaneo de Medidor', style: TextStyle(color: Colors.white)), 
        backgroundColor: const Color(0xFF005696),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                CameraPreview(_controller),
                Center(
                  child: Container(
                    width: 320,
                    height: 140,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.cyanAccent, width: 3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                if (_isProcessing)
                  Container(
                    color: Colors.black.withOpacity(0.5),
                    child: const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 15),
                          Text("Guardando lectura...", style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF005696),
        onPressed: _isProcessing ? null : () async {
          try {
            await _initializeControllerFuture;
            final image = await _controller.takePicture();
            final inputImage = InputImage.fromFilePath(image.path);
            final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
            final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
            textRecognizer.close();

            String mejorLectura = "";
            for (TextBlock block in recognizedText.blocks) {
              for (TextLine line in block.lines) {
                String soloNumeros = line.text.replaceAll(RegExp(r'[^0-9]'), '');
                if (soloNumeros.length >= 3 && soloNumeros.length <= 8) {
                  mejorLectura = soloNumeros;
                }
              }
            }

            if (context.mounted) {
              if (mejorLectura.isNotEmpty) {
                _mostrarResultado(mejorLectura, image.path);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('No se detectó una lectura clara. Intente de nuevo.'),
                    backgroundColor: Colors.orange,
                  )
                );
              }
            }
          } catch (e) {
            print("Error en captura: $e");
          }
        },
        label: const Text("CAPTURAR LECTURA",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.camera_alt, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
