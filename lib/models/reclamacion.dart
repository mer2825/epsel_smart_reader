import 'package:cloud_firestore/cloud_firestore.dart';

class Reclamacion {
  final String id;
  final String nombreCompleto;
  final String contacto;
  final String tipo;
  final String detalle;
  final DateTime fecha;
  final String estado;
  final String origen; // "Trabajador", "Jefe" o "Público General"

  Reclamacion({
    required this.id,
    required this.nombreCompleto,
    required this.contacto,
    required this.tipo,
    required this.detalle,
    required this.fecha,
    this.estado = 'Recibido',
    this.origen = 'Público General', // Valor por defecto
  });

  factory Reclamacion.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Reclamacion(
      id: doc.id,
      nombreCompleto: data['nombre_completo'] ?? '',
      contacto: data['contacto'] ?? '',
      tipo: data['tipo'] ?? 'Queja',
      detalle: data['detalle'] ?? '',
      fecha: (data['fecha'] as Timestamp).toDate(),
      estado: data['estado'] ?? 'Recibido',
      origen: data['origen'] ?? 'Público General',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre_completo': nombreCompleto,
      'contacto': contacto,
      'tipo': tipo,
      'detalle': detalle,
      'fecha': Timestamp.fromDate(fecha),
      'estado': estado,
      'origen': origen,
    };
  }
}
