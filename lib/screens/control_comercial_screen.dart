import 'package:flutter/material.dart';

class ControlComercialScreen extends StatelessWidget {
  const ControlComercialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Colores del CSS
    const Color azulFuerteFondo = Color(0xFF005B96);
    const Color celesteClaroPaneles = Color(0xFFD4E6F1);
    const Color azulOscuroBordes = Color(0xFF002D54);
    const Color azulHeader = Color(0xFF004070);

    return Scaffold(
      backgroundColor: azulFuerteFondo,
      body: Center(
        child: Container(
          width: 1100,
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: celesteClaroPaneles,
            border: Border.all(color: azulOscuroBordes, width: 3),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 24,
                offset: const Offset(0, 8),
              )
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(azulHeader, azulOscuroBordes),
                const SizedBox(height: 15),
                _buildDatosSuministro(azulHeader),
                const SizedBox(height: 15),
                _buildEstadoCuenta(azulHeader, azulOscuroBordes),
                const SizedBox(height: 15),
                _buildHistoricoLecturas(azulHeader, azulOscuroBordes),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- WIDGETS DE SECCIÓN ---

  Widget _buildHeader(Color azulHeader, Color azulOscuroBordes) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: azulHeader,
        borderRadius: BorderRadius.circular(6),
        border: Border(bottom: BorderSide(color: azulOscuroBordes, width: 3)),
      ),
      child: const Row(
        children: [
          // Aquí iría el logo si lo tuviéramos como widget
          Text(
            'Empresa Prestadora de Servicios...',
            style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildDatosSuministro(Color azulHeader) {
    return _SectionCard(
      title: 'DATOS DEL SUMINISTRO',
      titleColor: azulHeader,
      child: GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 6, // Ajustar para que los campos no sean tan altos
        children: [
          _buildFormField('Nro. Suministro:', '34546765'),
          _buildFormField('Ruta:', 'CH-01-105'),
          _buildFormField('Tipo de Suministro:', 'Agua Potable y Alcantarillado'),
          _buildFormField('Nombre / Cliente:', 'Reque Díaz, José Feliciano'),
          _buildFormField('Dirección:', 'Calle Los Olivos 350 Urb. San Juan'),
          _buildFormField('Nro. Medidor / Serie:', '12345678'),
        ],
      ),
    );
  }

  Widget _buildEstadoCuenta(Color azulHeader, Color azulOscuroBordes) {
    return _SectionCard(
      title: 'ESTADO DE CUENTA / DETALLE COMERCIAL',
      titleColor: azulHeader,
      child: Text("Aquí irá la tabla de estado de cuenta..."), // Placeholder
    );
  }

  Widget _buildHistoricoLecturas(Color azulHeader, Color azulOscuroBordes) {
    return _SectionCard(
      title: 'HISTÓRICO DE LECTURAS REGISTRADAS',
      titleColor: azulHeader,
      child: Text("Aquí irá la tabla de histórico de lecturas..."), // Placeholder
    );
  }

  // --- WIDGETS AUXILIARES ---

  Widget _buildFormField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF004070)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF004070), width: 2),
                borderRadius: BorderRadius.circular(4),
                color: Colors.white,
              ),
              child: Text(value, style: const TextStyle(fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget reutilizable para las tarjetas de sección
class _SectionCard extends StatelessWidget {
  final String title;
  final Color titleColor;
  final Widget child;

  const _SectionCard({required this.title, required this.titleColor, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF004070), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: titleColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(0), // Ajustado para que quede dentro
                topRight: Radius.circular(0),
              ),
            ),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
