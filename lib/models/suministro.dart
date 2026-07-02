import 'package:cloud_firestore/cloud_firestore.dart';

class Suministro {
  final String codigoSuministro;
  final String idCliente;
  final String direccionMedidor;
  final String estadoMedidor; // 'Activo', 'Suspendido'
  final double lecturaAnterior;

  Suministro({
    required this.codigoSuministro,
    required this.idCliente,
    required this.direccionMedidor,
    required this.estadoMedidor,
    required this.lecturaAnterior,
  });

  factory Suministro.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Suministro(
      codigoSuministro: doc.id,
      idCliente: data['id_cliente'] ?? '',
      direccionMedidor: data['direccion_medidor'] ?? '',
      estadoMedidor: data['estado_medidor'] ?? 'Activo',
      lecturaAnterior: (data['lectura_anterior'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_cliente': idCliente,
      'direccion_medidor': direccionMedidor,
      'estado_medidor': estadoMedidor,
      'lectura_anterior': lecturaAnterior,
    };
  }
}
