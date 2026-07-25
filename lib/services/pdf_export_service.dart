import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import '../models/reclamo.dart';

class PdfExportService {
  Future<void> exportarReclamosAPdf(List<Reclamo> reclamos) async {
    final pdf = pw.Document();

    // --- Cargar recursos (logo y fuentes) ---
    final logo = pw.MemoryImage(
      (await rootBundle.load('assets/images/logo_epsel.jpeg')).buffer.asUint8List(),
    );
    // Esta función descarga la fuente de Google Fonts automáticamente si no está en caché.
    // Es el equivalente a usar una librería de JS para las fuentes.
    final font = await PdfGoogleFonts.robotoRegular();
    final boldFont = await PdfGoogleFonts.robotoBold();

    // --- Construir el PDF ---
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        header: (pw.Context context) {
          return _buildHeader(context, logo, boldFont);
        },
        footer: (pw.Context context) {
          return _buildFooter(context, boldFont);
        },
        build: (pw.Context context) {
          return [
            _buildTablaReclamos(reclamos, font, boldFont),
          ];
        },
      ),
    );

    // --- Mostrar y descargar el PDF ---
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  pw.Widget _buildHeader(pw.Context context, pw.MemoryImage logo, pw.Font boldFont) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 10),
      decoration: const pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey, width: 2)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Row(
            children: [
              pw.Image(logo, height: 50),
              pw.SizedBox(width: 10),
              pw.Text(
                'Reporte de Libro de Reclamaciones',
                style: pw.TextStyle(font: boldFont, fontSize: 18),
              ),
            ],
          ),
          pw.Text(
            'Fecha: ${DateFormat('dd/MM/yyyy').format(DateTime.now())}',
            style: const pw.TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildFooter(pw.Context context, pw.Font boldFont) {
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      child: pw.Text(
        'Página ${context.pageNumber} de ${context.pagesCount}',
        style: pw.TextStyle(font: boldFont, fontSize: 10),
      ),
    );
  }

  pw.Widget _buildTablaReclamos(List<Reclamo> reclamos, pw.Font font, pw.Font boldFont) {
    final headers = ['Fecha', 'Tipo', 'Cliente', 'DNI', 'Descripción'];
    
    final data = reclamos.map((reclamo) {
      return [
        DateFormat('dd/MM/yy').format(reclamo.fecha),
        reclamo.tipo,
        reclamo.nombreCompleto,
        reclamo.dni,
        reclamo.descripcion,
      ];
    }).toList();

    return pw.Table.fromTextArray(
      headers: headers,
      data: data,
      headerStyle: pw.TextStyle(font: boldFont, color: PdfColors.white),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.blueGrey),
      cellStyle: pw.TextStyle(font: font),
      cellAlignments: {
        0: pw.Alignment.center,
        1: pw.Alignment.center,
        4: pw.Alignment.topLeft,
      },
    );
  }
}
