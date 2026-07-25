import 'package:cloud_firestore/cloud_firestore.dart';

class Reclamacion {
  final String id;
  final String nombreCompleto;
  final String contacto; // Puede ser email o teléfono
  final String tipo; // "Reclamo" o "Queja"
  final String detalle;
  final DateTime fecha;
  final String estado; // "Recibido", "En Proceso", "Resuelto"

  Reclamacion({
    required this.id,
    required this.nombreCompleto,
    required this.contacto,
    required this.tipo,
    required this.detalle,
    required this.fecha,
    this.estado = 'Recibido',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre_completo': nombreCompleto,
      'contacto': contacto,
      'tipo': tipo,
      'detalle': detalle,
      'fecha': Timestamp.fromDate(fecha),
      'estado': estado,
    };
  }
}
