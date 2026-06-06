import 'package:cloud_firestore/cloud_firestore.dart';

class Lectura {
  final String? idLectura; // Puede ser null antes de guardarse
  final String codigoSuministro;
  final String idRuta;
  final DateTime fechaLectura;
  final double lecturaAnterior;
  final double lecturaActual;
  final double consumoCalculado;
  final String fotoUrl;
  final String estadoLectura; // 'Leído', 'Atípico', 'No accesible'
  final double latitud;
  final double longitud;

  Lectura({
    this.idLectura,
    required this.codigoSuministro,
    required this.idRuta,
    required this.fechaLectura,
    required this.lecturaAnterior,
    required this.lecturaActual,
    required this.consumoCalculado,
    required this.fotoUrl,
    required this.estadoLectura,
    required this.latitud,
    required this.longitud,
  });

  factory Lectura.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Lectura(
      idLectura: doc.id,
      codigoSuministro: data['codigo_suministro'] ?? '',
      idRuta: data['id_ruta'] ?? '',
      fechaLectura: (data['fecha_lectura'] as Timestamp).toDate(),
      lecturaAnterior: (data['lectura_anterior'] ?? 0.0).toDouble(),
      lecturaActual: (data['lectura_actual'] ?? 0.0).toDouble(),
      consumoCalculado: (data['consumo_calculado'] ?? 0.0).toDouble(),
      fotoUrl: data['foto_url'] ?? '',
      estadoLectura: data['estado_lectura'] ?? 'Leído',
      latitud: (data['latitud'] ?? 0.0).toDouble(),
      longitud: (data['longitud'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'codigo_suministro': codigoSuministro,
      'id_ruta': idRuta,
      'fecha_lectura': Timestamp.fromDate(fechaLectura),
      'lectura_anterior': lecturaAnterior,
      'lectura_actual': lecturaActual,
      'consumo_calculado': consumoCalculado,
      'foto_url': fotoUrl,
      'estado_lectura': estadoLectura,
      'latitud': latitud,
      'longitud': longitud,
    };
  }
}
