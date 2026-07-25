import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../models/ruta_asignada.dart';
import 'scanner_screen.dart';
import '../main.dart';

class RutaDetalleScreen extends StatelessWidget {
  final RutaAsignada ruta;

  const RutaDetalleScreen({super.key, required this.ruta});

  @override
  Widget build(BuildContext context) {
    final CameraDescription? camera = firstCamera;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de la Ruta'),
        backgroundColor: const Color(0xFF005696),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: ruta.suministrosIds.length,
        itemBuilder: (context, index) {
          final suministroId = ruta.suministrosIds[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: CircleAvatar(
                child: Text('${index + 1}'),
              ),
              title: Text('Suministro ID: $suministroId'),
              subtitle: const Text('Dirección de prueba...'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                if (camera != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ScannerScreen(
                        camera: camera,
                        idRuta: ruta.idRuta, // Pasamos el ID de la ruta
                        codigoSuministro: suministroId, // Pasamos el ID del suministro
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cámara no disponible.')),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
