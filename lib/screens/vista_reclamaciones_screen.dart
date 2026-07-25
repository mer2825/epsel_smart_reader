import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
            padding: const EdgeInsets.all(10),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final data = doc.data() as Map<String, dynamic>;
              
              final reclamacion = Reclamacion(
                id: doc.id,
                nombreCompleto: data['nombre_completo'],
                contacto: data['contacto'],
                tipo: data['tipo'],
                detalle: data['detalle'],
                fecha: (data['fecha'] as Timestamp).toDate(),
                estado: data['estado'],
              );

              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                elevation: 3,
                child: ListTile(
                  isThreeLine: true,
                  leading: CircleAvatar(
                    backgroundColor: reclamacion.tipo == 'Reclamo' ? Colors.red.shade100 : Colors.amber.shade100,
                    child: Icon(
                      reclamacion.tipo == 'Reclamo' ? Icons.gavel : Icons.comment,
                      color: reclamacion.tipo == 'Reclamo' ? Colors.red : Colors.amber.shade800,
                    ),
                  ),
                  title: Text(reclamacion.nombreCompleto, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    '${reclamacion.tipo}: ${reclamacion.detalle}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Chip(
                    label: Text(reclamacion.estado),
                    backgroundColor: reclamacion.estado == 'Recibido' ? Colors.blue.shade100 : Colors.green.shade100,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
