import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/usuario.dart';
import '../models/ruta_asignada.dart';
import '../models/lectura.dart';
import '../models/reclamo.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // ... (otras funciones)
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      print("Error de autenticación: ${e.message}");
      return null;
    }
  }

  Future<Usuario?> getUsuarioPorUid(String uid) async {
    try {
      DocumentSnapshot doc = await _db.collection('usuarios').doc(uid).get();
      if (doc.exists) {
        return Usuario.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print("Error al obtener usuario por UID: $e");
      return null;
    }
  }

  Future<List<Usuario>> getTrabajadores() async {
    try {
      QuerySnapshot snapshot = await _db
          .collection('usuarios')
          .where('rol', isEqualTo: 'trabajador')
          .get();
      
      return snapshot.docs.map((doc) => Usuario.fromFirestore(doc)).toList();
    } catch (e) {
      print("Error al obtener trabajadores: $e");
      return [];
    }
  }

  Future<String> registrarNuevoTrabajador({
    required String email,
    required String dni,
    required String nombres,
    required String apellidos,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: dni,
      );

      if (userCredential.user != null) {
        String uid = userCredential.user!.uid;
        
        Usuario nuevoUsuario = Usuario(
          id: uid,
          dni: dni,
          nombres: nombres,
          apellidos: apellidos,
          rol: 'trabajador',
        );

        await _db.collection('usuarios').doc(uid).set(nuevoUsuario.toJson());
        
        return "¡Trabajador registrado con éxito!";
      }
      return "Error: No se pudo obtener el usuario creado.";

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'Error: La contraseña (DNI) es demasiado débil.';
      } else if (e.code == 'email-already-in-use') {
        return 'Error: El correo electrónico ya está en uso.';
      }
      return 'Error de autenticación: ${e.message}';
    } catch (e) {
      return 'Error inesperado: $e';
    }
  }

  Future<String> asignarNuevaRuta({
    required String idUsuario,
    required DateTime fechaAsignacion,
    required List<String> suministrosIds,
  }) async {
    try {
      DocumentReference docRef = _db.collection('rutas_asignadas').doc();

      RutaAsignada nuevaRuta = RutaAsignada(
        idRuta: docRef.id,
        idUsuario: idUsuario,
        fechaAsignacion: fechaAsignacion,
        estado: 'Pendiente',
        suministrosIds: suministrosIds,
      );

      await docRef.set(nuevaRuta.toJson());

      return "¡Ruta asignada con éxito!";
    } catch (e) {
      return "Error al asignar la ruta: $e";
    }
  }

  Future<int> getLecturasCount() async {
    try {
      AggregateQuerySnapshot snapshot = await _db.collection('lecturas').count().get();
      return snapshot.count ?? 0;
    } catch (e) {
      print("Error al contar lecturas: $e");
      return 0;
    }
  }

  Future<String> guardarLectura({
    required String idRuta,
    required String codigoSuministro,
    required double lecturaActual,
    required File foto,
  }) async {
    try {
      Lectura nuevaLectura = Lectura(
        codigoSuministro: codigoSuministro,
        idRuta: idRuta,
        fechaLectura: DateTime.now(),
        lecturaAnterior: 0.0,
        lecturaActual: lecturaActual,
        consumoCalculado: 0.0,
        fotoUrl: '',
        estadoLectura: 'Leído',
        latitud: 0.0,
        longitud: 0.0,
      );

      await _db.collection('lecturas').add(nuevaLectura.toJson());

      return "Lectura guardada con éxito (sin foto)";
    } catch (e) {
      print("Error al guardar lectura en Firestore: $e");
      return "Error al guardar la lectura";
    }
  }

  Future<List<RutaAsignada>> getMisRutas(String idUsuario) async {
    try {
      QuerySnapshot snapshot = await _db
          .collection('rutas_asignadas')
          .where('id_usuario', isEqualTo: idUsuario)
          .get();
      
      return snapshot.docs.map((doc) => RutaAsignada.fromFirestore(doc)).toList();
    } catch (e) {
      print("Error al obtener mis rutas: $e");
      return [];
    }
  }

  Future<String> guardarReclamo(Reclamo reclamo) async {
    try {
      await _db.collection('reclamos').doc(reclamo.id).set(reclamo.toJson());
      return "Reclamo enviado con éxito. Su código de seguimiento es: ${reclamo.id}";
    } catch (e) {
      print("Error al guardar reclamo: $e");
      return "Error al enviar el reclamo. Por favor, intente de nuevo.";
    }
  }

  Future<List<Reclamo>> getReclamos() async {
    try {
      QuerySnapshot snapshot = await _db.collection('reclamos').orderBy('fecha', descending: true).get();
      return snapshot.docs.map((doc) => Reclamo.fromFirestore(doc)).toList();
    } catch (e) {
      print("Error al obtener reclamos: $e");
      return [];
    }
  }

  // --- NUEVAS FUNCIONES STREAM ---
  Stream<List<Reclamo>> getReclamosStream() {
    return _db.collection('reclamos').orderBy('fecha', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Reclamo.fromFirestore(doc)).toList();
    });
  }

  Stream<int> getReclamosCountStream() {
    return _db.collection('reclamos').snapshots().map((snapshot) => snapshot.size);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
