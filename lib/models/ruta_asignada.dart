import 'package:cloud_firestore/cloud_firestore.dart';

class RutaAsignada {
  final String idRuta;
  final String idUsuario; // El trabajador asignado
  final DateTime fechaAsignacion;
  final String estado; // 'Pendiente', 'En progreso', 'Completada'
  final List<String> suministrosIds; // Lista de códigos de los suministros a leer

  RutaAsignada({
    required this.idRuta,
    required this.idUsuario,
    required this.fechaAsignacion,
    required this.estado,
    required this.suministrosIds,
  });

  factory RutaAsignada.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return RutaAsignada(
      idRuta: doc.id,
      idUsuario: data['id_usuario'] ?? '',
      fechaAsignacion: (data['fecha_asignacion'] as Timestamp).toDate(),
      estado: data['estado'] ?? 'Pendiente',
      suministrosIds: List<String>.from(data['suministros'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_usuario': idUsuario,
      'fecha_asignacion': Timestamp.fromDate(fechaAsignacion),
      'estado': estado,
      'suministros': suministrosIds,
    };
  }
}
