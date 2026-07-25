import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Paquete para formatear fechas
import '../models/reclamacion.dart';

class VistaReclamacionesScreen extends StatelessWidget {
  const VistaReclamacionesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Libro de Reclamaciones'),
        backgroundColor: const Color(0xFF002B49),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('reclamaciones').orderBy('fecha', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No hay reclamaciones registradas.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final reclamacion = Reclamacion.fromFirestore(doc);

              return _buildReclamacionCard(reclamacion);
            },
          );
        },
      ),
    );
  }

  Widget _buildReclamacionCard(Reclamacion reclamacion) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm');
    final String fechaFormateada = formatter.format(reclamacion.fecha);

    IconData tipoIcon;
    Color tipoColor;
    switch (reclamacion.tipo) {
      case 'Reclamo':
        tipoIcon = Icons.gavel;
        tipoColor = Colors.red.shade700;
        break;
      case 'Queja':
      default:
        tipoIcon = Icons.comment_bank;
        tipoColor = Colors.amber.shade800;
        break;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Cabecera con Nombre, Origen y Fecha ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    reclamacion.nombreCompleto,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Chip(
                  label: Text(reclamacion.estado, style: const TextStyle(fontSize: 10)),
                  backgroundColor: reclamacion.estado == 'Recibido' ? Colors.blue.shade100 : Colors.green.shade100,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                ),
              ],
            ),
            Text(
              'Origen: ${reclamacion.origen}',
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 5),
            Text(
              'Fecha: $fechaFormateada',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const Divider(height: 20),

            // --- Cuerpo del Reclamo ---
            Row(
              children: [
                Icon(tipoIcon, color: tipoColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  reclamacion.tipo.toUpperCase(),
                  style: TextStyle(fontWeight: FontWeight.bold, color: tipoColor),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(reclamacion.detalle),
            const Divider(height: 20),

            // --- Pie con Contacto ---
            Row(
              children: [
                const Icon(Icons.contact_mail, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text('Contacto: ${reclamacion.contacto}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
