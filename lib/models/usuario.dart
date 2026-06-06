import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario {
  final String id;
  final String dni;
  final String nombres;
  final String apellidos;
  final String rol; // 'trabajador' o 'jefe'

  Usuario({
    required this.id,
    required this.dni,
    required this.nombres,
    required this.apellidos,
    required this.rol,
  });

  // Método para convertir un documento de Firestore a un objeto Usuario
  factory Usuario.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Usuario(
      id: doc.id,
      dni: data['dni'] ?? '',
      nombres: data['nombres'] ?? '',
      apellidos: data['apellidos'] ?? '',
      rol: data['rol'] ?? 'trabajador',
    );
  }

  // Método para convertir un objeto Usuario a un mapa para Firestore
  Map<String, dynamic> toJson() {
    return {
      'dni': dni,
      'nombres': nombres,
      'apellidos': apellidos,
      'rol': rol,
    };
  }
}
