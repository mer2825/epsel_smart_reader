import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/reclamo.dart';
import '../services/firebase_service.dart';

class LibroReclamacionesScreen extends StatefulWidget {
  const LibroReclamacionesScreen({super.key});

  @override
  State<LibroReclamacionesScreen> createState() => _LibroReclamacionesScreenState();
}

class _LibroReclamacionesScreenState extends State<LibroReclamacionesScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _dniController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _pedidoController = TextEditingController();

  String _tipoSeleccionado = 'Reclamo';
  bool _isLoading = false;

  final FirebaseService _firebaseService = FirebaseService();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() { _isLoading = true; });

      var reclamo = Reclamo(
        id: const Uuid().v4(),
        nombreCompleto: _nombreController.text,
        dni: _dniController.text,
        email: _emailController.text,
        telefono: _telefonoController.text,
        tipo: _tipoSeleccionado,
        descripcion: _descripcionController.text,
        pedido: _pedidoController.text,
        fecha: DateTime.now(),
      );

      String resultado = await _firebaseService.guardarReclamo(reclamo);

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(resultado.contains('éxito') ? 'Envío Exitoso' : 'Error'),
            content: Text(resultado),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  if (resultado.contains('éxito')) {
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
        setState(() { _isLoading = false; });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Libro de Reclamaciones'),
        backgroundColor: const Color(0xFF002B49),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(24.0),
              children: [
                const Text(
                  'Hoja de Reclamación',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF002B49)),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Conforme a lo establecido en el Código de Protección y Defensa del Consumidor, esta institución cuenta con un Libro de Reclamaciones a su disposición.',
                ),
                const Divider(height: 30),

                // --- CAMPOS DEL FORMULARIO AÑADIDOS ---
                _buildSectionTitle('1. Identificación del Consumidor'),
                _buildTextField(_nombreController, 'Nombre Completo'),
                const SizedBox(height: 15),
                _buildTextField(_dniController, 'DNI / Carnet de Extranjería'),
                const SizedBox(height: 15),
                _buildTextField(_emailController, 'Correo Electrónico', keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 15),
                _buildTextField(_telefonoController, 'Teléfono', keyboardType: TextInputType.phone),
                
                const Divider(height: 30),

                _buildSectionTitle('2. Identificación del Bien o Servicio Contratado'),
                DropdownButtonFormField<String>(
                  value: _tipoSeleccionado,
                  items: ['Reclamo', 'Queja'].map((String value) {
                    return DropdownMenuItem<String>(value: value, child: Text(value));
                  }).toList(),
                  onChanged: (newValue) => setState(() => _tipoSeleccionado = newValue!),
                  decoration: const InputDecoration(
                    labelText: 'Tipo (Reclamo / Queja)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _tipoSeleccionado == 'Reclamo'
                      ? 'Reclamo: Disconformidad relacionada a los productos o servicios.'
                      : 'Queja: Disconformidad no relacionada a los productos o servicios; o, malestar o descontento respecto a la atención al público.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),

                const Divider(height: 30),

                _buildSectionTitle('3. Detalle de la Reclamación y Pedido del Consumidor'),
                _buildTextField(_descripcionController, 'Descripción (Detalle del reclamo o queja)', maxLines: 4),
                const SizedBox(height: 15),
                _buildTextField(_pedidoController, 'Pedido (Ej: Devolución, cambio, reparación, etc.)', maxLines: 2),
                // --- FIN DE CAMPOS DEL FORMULARIO ---

                const SizedBox(height: 24),
                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF005696),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Enviar Reclamación', style: TextStyle(fontSize: 16)),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF004070)),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {int maxLines = 1, TextInputType? keyboardType}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        alignLabelWithHint: true,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Este campo es obligatorio';
        }
        return null;
      },
    );
  }
}
