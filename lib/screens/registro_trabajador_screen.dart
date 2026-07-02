import 'package:flutter/material.dart';
import '../services/firebase_service.dart';

class RegistroTrabajadorScreen extends StatefulWidget {
  const RegistroTrabajadorScreen({super.key});

  @override
  State<RegistroTrabajadorScreen> createState() => _RegistroTrabajadorScreenState();
}

class _RegistroTrabajadorScreenState extends State<RegistroTrabajadorScreen> {
  final _dniController = TextEditingController();
  final _nombresController = TextEditingController();
  final _apellidosController = TextEditingController();
  final _direccionController = TextEditingController();
  final _distritoController = TextEditingController();
  final _celularController = TextEditingController();
  final _correoController = TextEditingController();

  final FirebaseService _firebaseService = FirebaseService();
  bool _isLoading = false;

  Future<void> _handleRegistro() async {
    setState(() { _isLoading = true; });

    // Validar que los campos no estén vacíos
    if (_dniController.text.isEmpty || 
        _nombresController.text.isEmpty || 
        _apellidosController.text.isEmpty || 
        _correoController.text.isEmpty) {
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('DNI, Nombres, Apellidos y Correo son obligatorios.'), backgroundColor: Colors.orange),
      );
      setState(() { _isLoading = false; });
      return;
    }

    String resultado = await _firebaseService.registrarNuevoTrabajador(
      email: _correoController.text.trim(),
      dni: _dniController.text.trim(),
      nombres: _nombresController.text.trim(),
      apellidos: _apellidosController.text.trim(),
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(resultado),
          backgroundColor: resultado.contains('éxito') ? Colors.green : Colors.red,
        ),
      );
      
      if (resultado.contains('éxito')) {
        // Si el registro fue exitoso, cerramos la pantalla después de un momento
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
              // Header y Navbar (similares a la otra pantalla)
              // ...
              Expanded(
                child: _buildSectionCard(
                  title: 'FORMULARIO DE NUEVO TRABAJADOR',
                  titleColor: azulHeader,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3, // El formulario ocupa más espacio
                        child: _buildFormulario(),
                      ),
                      const SizedBox(width: 40),
                      _buildPanelAcciones(),
                    ],
                  ),
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

  Widget _buildFormulario() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildFormField('CÓDIGO', TextEditingController(text: 'EP-XXXXXX'), isReadOnly: true),
          _buildFormField('DNI', _dniController),
          _buildFormField('NOMBRES', _nombresController),
          _buildFormField('APELLIDOS', _apellidosController),
          _buildFormField('DIRECCIÓN', _direccionController),
          _buildFormField('DISTRITO', _distritoController),
          _buildFormField('CELULAR', _celularController),
          _buildFormField('CORREO', _correoController, isEmail: true),
        ],
      ),
    );
  }

  Widget _buildFormField(String label, TextEditingController controller, {bool isReadOnly = false, bool isEmail = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Container(
            width: 120,
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
              keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
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

  Widget _buildPanelAcciones() {
    return Column(
      children: [
        if (_isLoading)
          const CircularProgressIndicator()
        else
          ElevatedButton(
            onPressed: _handleRegistro,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF27AE60),
              foregroundColor: Colors.white,
              minimumSize: const Size(160, 40),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            child: const Text('GUARDAR'),
          ),
        const SizedBox(height: 15),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFC0392B),
            foregroundColor: Colors.white,
            minimumSize: const Size(160, 40),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ),
          child: const Text('CANCELAR'),
        ),
      ],
    );
  }
}
