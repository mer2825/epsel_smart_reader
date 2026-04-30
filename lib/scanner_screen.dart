import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class ScannerScreen extends StatefulWidget {
  final CameraDescription camera;
  const ScannerScreen({super.key, required this.camera});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // Resolución medium es ideal para el enfoque de medidores
    _controller = CameraController(widget.camera, ResolutionPreset.medium, enableAudio: false);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // MODIFICADO: Envía el número y la foto de regreso a la Hoja de Lectura
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
              Navigator.pop(context); // Cierra el diálogo
              
              // RETORNO DE DATOS: Mandamos el Mapa a la pantalla anterior
              Navigator.pop(context, {
                'lectura': valor,
                'fotoPath': pathImagen
              });
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
                // Visor estilo Figma (Marco de enfoque)
                Center(
                  child: Container(
                    width: 320,
                    height: 140,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.cyanAccent, width: 3),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 2
                        )
                      ],
                    ),
                  ),
                ),
                const Positioned(
                  bottom: 150,
                  left: 0,
                  right: 0,
                  child: Text(
                    "Encuadre los números del medidor aquí",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, backgroundColor: Colors.black45),
                  ),
                )
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF005696),
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            
            // 1. Capturamos la foto física (archivo temporal)
            final image = await _controller.takePicture();
            
            // 2. Procesamos el texto con ML Kit
            final inputImage = InputImage.fromFilePath(image.path);
            final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
            final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
            
            String mejorLectura = "";
            
            for (TextBlock block in recognizedText.blocks) {
              for (TextLine line in block.lines) {
                // Filtramos solo números
                String soloNumeros = line.text.replaceAll(RegExp(r'[^0-9]'), '');
                // Validamos longitud típica de medidores (ej. 4 a 8 dígitos)
                if (soloNumeros.length >= 3 && soloNumeros.length <= 8) {
                  mejorLectura = soloNumeros;
                }
              }
            }

            textRecognizer.close();

            if (context.mounted) {
              if (mejorLectura.isNotEmpty) {
                // ÉXITO: Mostramos diálogo y enviamos ruta de la imagen
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