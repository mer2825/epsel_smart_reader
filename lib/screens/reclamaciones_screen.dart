import 'package:flutter/material.dart';
import '../services/firebase_service.dart';

class ReclamacionesScreen extends StatefulWidget {
  const ReclamacionesScreen({super.key});

  @override
  State<ReclamacionesScreen> createState() => _ReclamacionesScreenState();
}

class _ReclamacionesScreenState extends State<ReclamacionesScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _contactoController = TextEditingController();
  final _detalleController = TextEditingController();
  String _tipoSeleccionado = 'Queja';
  bool _isLoading = false;

  final FirebaseService _firebaseService = FirebaseService();

  Future<void> _enviarFormulario() async {
    if (_formKey.currentState!.validate()) {
      setState(() { _isLoading = true; });

      final resultado = await _firebaseService.enviarReclamacion(
        nombre: _nombreController.text,
        contacto: _contactoController.text,
        tipo: _tipoSeleccionado,
        detalle: _detalleController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(resultado),
            backgroundColor: resultado.contains('éxito') ? Colors.green : Colors.red,
          ),
        );
        if (resultado.contains('éxito')) {
          Navigator.pop(context);
        }
      }

      setState(() { _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Libro de Reclamaciones'),
        backgroundColor: const Color(0xFF005696),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Registre su queja o reclamo',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre Completo', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Este campo es obligatorio' : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _contactoController,
                decoration: const InputDecoration(labelText: 'Correo o Teléfono de Contacto', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Este campo es obligatorio' : null,
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value: _tipoSeleccionado,
                items: ['Queja', 'Reclamo'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _tipoSeleccionado = newValue!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Tipo', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _detalleController,
                decoration: const InputDecoration(
                  labelText: 'Detalle de su queja o reclamo',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 5,
                validator: (value) => value!.isEmpty ? 'Este campo es obligatorio' : null,
              ),
              const SizedBox(height: 30),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                      onPressed: _enviarFormulario,
                      icon: const Icon(Icons.send),
                      label: const Text('Enviar Reclamación'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        backgroundColor: const Color(0xFF005696),
                        foregroundColor: Colors.white,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
