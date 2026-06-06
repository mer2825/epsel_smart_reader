import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/usuario.dart';
import '../models/lectura.dart';
import '../models/ruta_asignada.dart';
import '../models/suministro.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- Operaciones con Usuarios ---

  /// Busca un usuario por su DNI y contraseña (simulada, ya que no guardamos pass).
  /// En una app real, esto se manejaría con Firebase Auth.
  Future<Usuario?> getUsuarioPorCredenciales(String dni) async {
    try {
      QuerySnapshot snapshot = await _db
          .collection('usuarios')
          .where('dni', isEqualTo: dni)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return Usuario.fromFirestore(snapshot.docs.first);
      }
      return null; // No se encontró el usuario
    } catch (e) {
      print("Error al obtener usuario: $e");
      return null;
    }
  }

  // --- Operaciones con Lecturas ---

  /// Guarda una nueva lectura en la base de datos.
  Future<void> guardarLectura(Lectura lectura) async {
    try {
      await _db.collection('lecturas').add(lectura.toJson());
    } catch (e) {
      print("Error al guardar la lectura: $e");
      // Aquí podrías manejar el error, por ejemplo, mostrando una notificación.
    }
  }

  /// Obtiene el historial de lecturas para un suministro específico.
  Stream<List<Lectura>> getHistorialDeLecturas(String codigoSuministro) {
    return _db
        .collection('lecturas')
        .where('codigo_suministro', isEqualTo: codigoSuministro)
        .orderBy('fecha_lectura', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Lectura.fromFirestore(doc))
            .toList());
  }
  
  // --- Operaciones con Rutas y Suministros ---

  /// Obtiene la ruta asignada a un trabajador para el día de hoy.
  Stream<RutaAsignada?> getRutaDelDia(String idUsuario) {
    // Lógica para filtrar por fecha actual (simplificada)
    return _db
        .collection('rutas_asignadas')
        .where('id_usuario', isEqualTo: idUsuario)
        .orderBy('fecha_asignacion', descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        return RutaAsignada.fromFirestore(snapshot.docs.first);
      }
      return null;
    });
  }

  /// Obtiene los detalles de un suministro específico.
  Future<Suministro?> getSuministro(String codigoSuministro) async {
    try {
      DocumentSnapshot doc = await _db.collection('suministros').doc(codigoSuministro).get();
      if (doc.exists) {
        return Suministro.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print("Error al obtener suministro: $e");
      return null;
    }
  }
}
