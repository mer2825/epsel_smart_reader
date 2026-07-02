import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../models/usuario.dart';

class AsignacionTareasScreen extends StatefulWidget {
  final Usuario trabajador;

  const AsignacionTareasScreen({super.key, required this.trabajador});

  @override
  State<AsignacionTareasScreen> createState() => _AsignacionTareasScreenState();
}

class _AsignacionTareasScreenState extends State<AsignacionTareasScreen> {
  final _localidadController = TextEditingController();
  final _calleController = TextEditingController();
  final _sectorController = TextEditingController();
  final _cuadrillaController = TextEditingController();
  
  late TextEditingController _codigoController;
  late TextEditingController _nombresController;
  late TextEditingController _apellidosController;

  final FirebaseService _firebaseService = FirebaseService();
  bool _isLoading = false;
  DateTime? _fechaSeleccionada;

  @override
  void initState() {
    super.initState();
    _trabajadorSeleccionado = widget.trabajador;
    _codigoController = TextEditingController(text: _trabajadorSeleccionado?.dni);
    _nombresController = TextEditingController(text: _trabajadorSeleccionado?.nombres);
    _apellidosController = TextEditingController(text: _trabajadorSeleccionado?.apellidos);
  }

  Usuario? _trabajadorSeleccionado;

  Future<void> _handleGuardarAsignacion() async {
    if (_trabajadorSeleccionado == null || _fechaSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debe seleccionar un trabajador y una fecha.'), backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() { _isLoading = true; });

    // Aquí iría la lógica para obtener los IDs de los suministros de la ruta.
    // Por ahora, usaremos una lista de prueba.
    List<String> suministrosDePrueba = ['SUM-001', 'SUM-002', 'SUM-003'];

    String resultado = await _firebaseService.asignarNuevaRuta(
      idUsuario: _trabajadorSeleccionado!.id,
      fechaAsignacion: _fechaSeleccionada!,
      suministrosIds: suministrosDePrueba,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(resultado),
          backgroundColor: resultado.contains('éxito') ? Colors.green : Colors.red,
        ),
      );
      
      if (resultado.contains('éxito')) {
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) Navigator.pop(context);
        });
      }
    }

    setState(() { _isLoading = false; });
  }

  @override
  Widget build(BuildContext context) {
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
          ),
          child: Column(
            children: [
              Expanded(
                child: _buildSectionCard(
                  title: 'ASIGNACIÓN DE NUEVO TRABAJADOR DE CAMPO',
                  titleColor: azulHeader,
                  child: _buildFormularioAsignacion(),
                ),
              ),
            ],
          ),
        ),
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
              padding: const EdgeInsets.all(20.0),
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormularioAsignacion() {
    return Column(
      children: [
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 7,
            children: [
              _buildFormField('CÓDIGO', _codigoController, isReadOnly: true),
              _buildFormField('LOCALIDAD', _localidadController),
              _buildFormField('NOMBRES', _nombresController, isReadOnly: true),
              _buildFormField('CALLE', _calleController),
              _buildFormField('APELLIDOS', _apellidosController, isReadOnly: true),
              _buildFormField('SECTOR', _sectorController),
              _buildDateField('FECHA'),
              _buildFormField('CUADRILLA', _cuadrillaController),
            ],
          ),
        ),
        _buildBotonesAcciones(),
      ],
    );
  }

  Widget _buildFormField(String label, TextEditingController controller, {bool isReadOnly = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.5, horizontal: 7.5),
      child: Row(
        children: [
          Container(
            width: 110,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: const BoxDecoration(
              color: Color(0xFF005B96),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(4), bottomLeft: Radius.circular(4)),
              border: Border(
                top: BorderSide(color: Color(0xFF002D54), width: 2),
                left: BorderSide(color: Color(0xFF002D54), width: 2),
                bottom: BorderSide(color: Color(0xFF002D54), width: 2),
              ),
            ),
            child: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
          Expanded(
            child: TextFormField(
              controller: controller,
              readOnly: isReadOnly,
              decoration: InputDecoration(
                filled: true,
                fillColor: isReadOnly ? Colors.white : const Color(0xFFEAF2F8),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(4), bottomRight: Radius.circular(4)),
                  borderSide: BorderSide(color: Color(0xFF002D54), width: 2),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(4), bottomRight: Radius.circular(4)),
                  borderSide: BorderSide(color: Color(0xFF002D54), width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.5, horizontal: 7.5),
      child: Row(
        children: [
          Container(
            width: 110,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: const BoxDecoration(
              color: Color(0xFF005B96),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(4), bottomLeft: Radius.circular(4)),
              border: Border(
                top: BorderSide(color: Color(0xFF002D54), width: 2),
                left: BorderSide(color: Color(0xFF002D54), width: 2),
                bottom: BorderSide(color: Color(0xFF002D54), width: 2),
              ),
            ),
            child: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
          Expanded(
            child: InkWell(
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _fechaSeleccionada ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (picked != null && picked != _fechaSeleccionada) {
                  setState(() {
                    _fechaSeleccionada = picked;
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF2F8),
                  border: Border.all(color: const Color(0xFF002D54), width: 2),
                  borderRadius: const BorderRadius.only(topRight: Radius.circular(4), bottomRight: Radius.circular(4)),
                ),
                child: Text(
                  _fechaSeleccionada == null
                      ? 'Seleccione fecha'
                      : "${_fechaSeleccionada!.toLocal()}".split(' ')[0],
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBotonesAcciones() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC0392B),
              foregroundColor: Colors.white,
              minimumSize: const Size(120, 40),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            child: const Text('CANCELAR'),
          ),
          const SizedBox(width: 15),
          ElevatedButton(
            onPressed: _isLoading ? null : _handleGuardarAsignacion,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF27AE60),
              foregroundColor: Colors.white,
              minimumSize: const Size(120, 40),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('GUARDAR'),
          ),
        ],
      ),
    );
  }
}
