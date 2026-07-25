import 'package:cloud_firestore/cloud_firestore.dart';

class Reclamo {
  final String id;
  final String nombreCompleto;
  final String dni;
  final String email;
  final String telefono;
  final String tipo; // 'Reclamo' o 'Queja'
  final String descripcion;
  final String pedido;
  final DateTime fecha;
  final bool respuestaEnviada;

  Reclamo({
    required this.id,
    required this.nombreCompleto,
    required this.dni,
    required this.email,
    required this.telefono,
    required this.tipo,
    required this.descripcion,
    required this.pedido,
    required this.fecha,
    this.respuestaEnviada = false,
  });

  // Convertir un objeto Reclamo a un mapa para Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombreCompleto': nombreCompleto,
      'dni': dni,
      'email': email,
      'telefono': telefono,
      'tipo': tipo,
      'descripcion': descripcion,
      'pedido': pedido,
      'fecha': fecha,
      'respuestaEnviada': respuestaEnviada,
    };
  }

  // Crear un objeto Reclamo desde un documento de Firestore
  factory Reclamo.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Reclamo(
      id: doc.id,
      nombreCompleto: data['nombreCompleto'] ?? '',
      dni: data['dni'] ?? '',
      email: data['email'] ?? '',
      telefono: data['telefono'] ?? '',
      tipo: data['tipo'] ?? '',
      descripcion: data['descripcion'] ?? '',
      pedido: data['pedido'] ?? '',
      fecha: (data['fecha'] as Timestamp).toDate(),
      respuestaEnviada: data['respuestaEnviada'] ?? false,
    );
  }
}
