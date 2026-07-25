import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/reclamo.dart';
import '../services/firebase_service.dart';
import '../services/pdf_export_service.dart';

class PanelReclamacionesScreen extends StatefulWidget {
  const PanelReclamacionesScreen({super.key});

  @override
  State<PanelReclamacionesScreen> createState() => _PanelReclamacionesScreenState();
}

class _PanelReclamacionesScreenState extends State<PanelReclamacionesScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  final PdfExportService _pdfExportService = PdfExportService();
  late Stream<List<Reclamo>> _reclamosStream;
  bool _isExporting = false;

  @override
  void initState() {
    super.initState();
    _reclamosStream = _firebaseService.getReclamosStream();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Reclamo>>(
      stream: _reclamosStream,
      builder: (context, snapshot) {
        // Obtenemos la lista de reclamos del snapshot actual
        final reclamos = snapshot.data ?? [];
        final bool hasData = reclamos.isNotEmpty;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Panel de Reclamaciones'),
            backgroundColor: const Color(0xFF002B49),
            foregroundColor: Colors.white,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: _isExporting
                    ? const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      )
                    : IconButton(
                        icon: const Icon(Icons.picture_as_pdf),
                        tooltip: 'Exportar a PDF',
                        // El botón se deshabilita si no hay datos o si ya se está exportando
                        onPressed: !hasData
                            ? null
                            : () async {
                                setState(() { _isExporting = true; });
                                try {
                                  await _pdfExportService.exportarReclamosAPdf(reclamos);
                                } catch (e) {
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Error al generar el PDF: $e')),
                                    );
                                  }
                                } finally {
                                  if (mounted) {
                                    setState(() { _isExporting = false; });
                                  }
                                }
                              },
                      ),
              ),
            ],
          ),
          body: _buildBody(snapshot),
        );
      },
    );
  }

  Widget _buildBody(AsyncSnapshot<List<Reclamo>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }
    if (snapshot.hasError) {
      return const Center(child: Text('Error al cargar los reclamos.'));
    }
    if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return const Center(child: Text('No hay reclamaciones para mostrar.'));
    }

    final reclamos = snapshot.data!;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Fecha')),
            DataColumn(label: Text('Tipo')),
            DataColumn(label: Text('Cliente')),
            DataColumn(label: Text('DNI')),
            DataColumn(label: Text('Estado')),
            DataColumn(label: Text('Acciones')),
          ],
          rows: reclamos.map((reclamo) => _buildDataRow(context, reclamo)).toList(),
        ),
      ),
    );
  }

  DataRow _buildDataRow(BuildContext context, Reclamo reclamo) {
    return DataRow(
      cells: [
        DataCell(Text(DateFormat('dd/MM/yyyy').format(reclamo.fecha))),
        DataCell(Text(reclamo.tipo)),
        DataCell(Text(reclamo.nombreCompleto)),
        DataCell(Text(reclamo.dni)),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text('Pendiente', style: TextStyle(color: Colors.white)),
          ),
        ),
        DataCell(
          ElevatedButton(
            child: const Text('Ver Detalle'),
            onPressed: () => _mostrarDetalleReclamo(context, reclamo),
          ),
        ),
      ],
    );
  }

  void _mostrarDetalleReclamo(BuildContext context, Reclamo reclamo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Detalle del ${reclamo.tipo}'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('**Cliente:** ${reclamo.nombreCompleto}'),
              const SizedBox(height: 8),
              Text('**Contacto:** ${reclamo.email} / ${reclamo.telefono}'),
              const Divider(height: 20),
              Text('**Descripción:**\n${reclamo.descripcion}'),
              const SizedBox(height: 16),
              Text('**Pedido del Cliente:**\n${reclamo.pedido}'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cerrar'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
