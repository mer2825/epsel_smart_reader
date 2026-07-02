import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../models/usuario.dart';
import 'registro_trabajador_screen.dart';
import 'asignacion_tareas_screen.dart';

class MonitoreoCampoScreen extends StatefulWidget {
  const MonitoreoCampoScreen({super.key});

  @override
  State<MonitoreoCampoScreen> createState() => _MonitoreoCampoScreenState();
}

class _MonitoreoCampoScreenState extends State<MonitoreoCampoScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  late Future<List<Usuario>> _trabajadoresFuture;

  @override
  void initState() {
    super.initState();
    _trabajadoresFuture = _firebaseService.getTrabajadores();
  }

  void _refrescarTrabajadores() {
    setState(() {
      _trabajadoresFuture = _firebaseService.getTrabajadores();
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color azulFuerteFondo = Color(0xFF005B96);
    const Color celesteClaroPaneles = Color(0xFFD4E6F1);
    const Color azulOscuroBordes = Color(0xFF002D54);
    const Color azulHeader = Color(0xFF004070);
    const Color verdeCabeceraTabla = Color(0xFF27AE60);

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
          ),
          child: Column(
            children: [
              _buildHeader(azulHeader, azulOscuroBordes),
              const SizedBox(height: 12),
              _buildBienvenidaBar(azulHeader),
              const SizedBox(height: 12),
              _buildNavBar(azulOscuroBordes),
              const SizedBox(height: 15),
              Expanded(
                child: _buildSectionCard(
                  title: 'VISTA DE TRABAJADORES ACTIVOS EN CAMPO',
                  titleColor: azulHeader,
                  child: FutureBuilder<List<Usuario>>(
                    future: _trabajadoresFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return const Center(child: Text("Error al cargar trabajadores"));
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text("No hay trabajadores para mostrar"));
                      }

                      final trabajadores = snapshot.data!;

                      return SingleChildScrollView(
                        child: _buildTablaMonitoreo(trabajadores, verdeCabeceraTabla, azulOscuroBordes),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RegistroTrabajadorScreen()),
          );
          _refrescarTrabajadores();
        },
        label: const Text('Registrar Nuevo'),
        icon: const Icon(Icons.add),
        backgroundColor: const Color(0xFF0073E6),
      ),
    );
  }

  Widget _buildHeader(Color azulHeader, Color azulOscuroBordes) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: azulHeader,
        borderRadius: BorderRadius.circular(6),
        border: Border(bottom: BorderSide(color: azulOscuroBordes, width: 3)),
      ),
      child: const Text(
        'Empresa Prestadora de Servicios de Saneamiento de Agua Potable y Alcantarillado de Lambayeque S.A.',
        style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildBienvenidaBar(Color colorTexto) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorTexto, width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '¡HOLA! BIENVENIDO: [NOMBRE DEL JEFE]',
            style: TextStyle(color: colorTexto, fontWeight: FontWeight.bold, fontSize: 12),
          ),
          TextButton(
            onPressed: () { /* Lógica de cerrar sesión */ },
            child: const Text(
              'CERRAR SESIÓN',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavBar(Color borderColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildNavButton('Inicio', borderColor, isActive: false),
        _buildNavButton('Notificación', borderColor, isActive: false),
        _buildNavButton('Tareas', borderColor, isActive: true),
        _buildNavButton('Configuración', borderColor, isActive: false),
      ],
    );
  }

  Widget _buildNavButton(String text, Color borderColor, {bool isActive = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: isActive ? const Color(0xFFF1C40F) : const Color(0xFF0073E6),
          foregroundColor: isActive ? const Color(0xFF002D54) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: borderColor, width: 2),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
        ),
        child: Text(text, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required Color titleColor, required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF004070), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: titleColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 0.5),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTablaMonitoreo(List<Usuario> trabajadores, Color headerColor, Color borderColor) {
    return Table(
      border: TableBorder.all(color: borderColor, width: 2),
      columnWidths: const {
        0: FlexColumnWidth(1.5),
        1: FlexColumnWidth(3),
        2: FlexColumnWidth(2),
        3: FlexColumnWidth(3),
        4: FlexColumnWidth(1.5),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(color: headerColor),
          children: [
            _buildHeaderCell('Código'),
            _buildHeaderCell('Apellidos y Nombres'),
            _buildHeaderCell('Localidad'),
            _buildHeaderCell('Sector y Calle'),
            _buildHeaderCell('Estado'),
          ],
        ),
        ...trabajadores.map((trabajador) => _buildHoverableTableRow(trabajador, borderColor)),
      ],
    );
  }

  TableRow _buildHoverableTableRow(Usuario trabajador, Color borderColor) {
    return TableRow(
      children: [
        _buildTableCell(trabajador.dni, trabajador),
        _buildTableCell('${trabajador.apellidos}, ${trabajador.nombres}', trabajador),
        _buildTableCell('Chiclayo', trabajador),
        _buildTableCell('Av. Balta - Sector 1', trabajador),
        _buildTableCellWidget(_buildEstadoBadge('EN CAMPO'), trabajador),
      ],
    );
  }

  Widget _buildHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTableCell(String text, Usuario trabajador) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AsignacionTareasScreen(trabajador: trabajador)),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF002D54)),
          ),
        ),
      ),
    );
  }
  
  Widget _buildTableCellWidget(Widget child, Usuario trabajador) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AsignacionTareasScreen(trabajador: trabajador)),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: child,
        ),
      ),
    );
  }

  Widget _buildEstadoBadge(String status) {
    Color bgColor = status == 'EN CAMPO' ? const Color(0xFFF1C40F) : const Color(0xFF2ECC71);
    Color textColor = status == 'EN CAMPO' ? Colors.black : Colors.white;
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: const Color(0xFF002D54)),
        ),
        child: Text(
          status,
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: textColor),
        ),
      ),
    );
  }
}
