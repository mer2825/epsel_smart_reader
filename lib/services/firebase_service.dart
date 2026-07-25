import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/usuario.dart';
import '../models/ruta_asignada.dart';
import '../models/lectura.dart';
import '../models/reclamacion.dart'; // Importamos el nuevo modelo

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // ... (código de autenticación y usuarios existente) ...

  Future<String> registrarNuevoTrabajador({
    required String email,
    required String dni,
    required String nombres,
    required String apellidos,
  }) async {
    // ... (código existente) ...
  }

  Future<String> asignarNuevaRuta({
    required String idUsuario,
    required DateTime fechaAsignacion,
    required List<String> suministrosIds,
  }) async {
    // ... (código existente) ...
  }

  Future<int> getLecturasCount() async {
    // ... (código existente) ...
  }

  Future<String> guardarLectura({
    required String idRuta,
    required String codigoSuministro,
    required double lecturaActual,
    required File foto,
  }) async {
    // ... (código existente) ...
  }

  // --- NUEVA FUNCIÓN PARA ENVIAR RECLAMACIONES ---
  Future<String> enviarReclamacion({
    required String nombre,
    required String contacto,
    required String tipo,
    required String detalle,
  }) async {
    try {
      DocumentReference docRef = _db.collection('reclamaciones').doc();
      
      Reclamacion nuevaReclamacion = Reclamacion(
        id: docRef.id,
        nombreCompleto: nombre,
        contacto: contacto,
        tipo: tipo,
        detalle: detalle,
        fecha: DateTime.now(),
      );

      await docRef.set(nuevaReclamacion.toJson());
      return "Reclamación enviada con éxito.";
    } catch (e) {
      print("Error al enviar reclamación: $e");
      return "Error al enviar la reclamación. Intente de nuevo.";
    }
  }

  Future<List<RutaAsignada>> getMisRutas(String idUsuario) async {
    // ... (código existente) ...
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
