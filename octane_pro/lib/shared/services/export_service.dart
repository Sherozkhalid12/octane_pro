import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';

class ExportService {
  static final ExportService instance = ExportService._();
  ExportService._();

  final _dateFormatter = DateFormat('yyyy-MM-dd');
  final _dateTimeFormatter = DateFormat('yyyy-MM-dd HH:mm:ss');
  final _currencyFormatter =
      NumberFormat.currency(symbol: '\$', decimalDigits: 2);

  // PDF Export Methods
  Future<String?> exportToPDF({
    required String title,
    required String fileName,
    required List<Map<String, dynamic>> data,
    required List<String> headers,
    required List<String> columns,
    Map<String, dynamic>? summary,
    String? subtitle,
  }) async {
    try {
      final pdf = pw.Document();
      final now = DateTime.now();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          build: (context) => [
            // Header
            _buildPDFHeader(title, subtitle, now),
            pw.SizedBox(height: 20),

            // Summary if provided
            if (summary != null) ...[
              _buildPDFSummary(summary),
              pw.SizedBox(height: 20),
            ],

            // Table
            _buildPDFTable(headers, columns, data),

            // Footer
            pw.SizedBox(height: 20),
            _buildPDFFooter(now),
          ],
        ),
      );

      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName.pdf');
      await file.writeAsBytes(await pdf.save());

      return file.path;
    } catch (e) {
      debugPrint('PDF Export Error: $e');
      return null;
    }
  }

  pw.Widget _buildPDFHeader(String title, String? subtitle, DateTime now) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'OctanePro',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.red700,
                  ),
                ),
                if (subtitle != null)
                  pw.Text(
                    subtitle,
                    style: pw.TextStyle(fontSize: 14, color: PdfColors.grey700),
                  ),
              ],
            ),
            pw.Text(
              _dateFormatter.format(now),
              style: pw.TextStyle(fontSize: 12, color: PdfColors.grey600),
            ),
          ],
        ),
        pw.Divider(),
        pw.SizedBox(height: 10),
        pw.Text(
          title,
          style: pw.TextStyle(
            fontSize: 20,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      ],
    );
  }

  pw.Widget _buildPDFSummary(Map<String, dynamic> summary) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(5),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: summary.entries.map((entry) {
          return pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 5),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  entry.key,
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
                pw.Text(
                  entry.value is num
                      ? _currencyFormatter.format(entry.value)
                      : entry.value.toString(),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  pw.Widget _buildPDFTable(
    List<String> headers,
    List<String> columns,
    List<Map<String, dynamic>> data,
  ) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300),
      children: [
        // Header row
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey200),
          children: headers.map((header) {
            return pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(
                header,
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            );
          }).toList(),
        ),
        // Data rows
        ...data.map((row) {
          return pw.TableRow(
            children: columns.map((column) {
              final value = row[column];
              String displayValue = '-';
              if (value != null) {
                if (value is num) {
                  displayValue = _currencyFormatter.format(value);
                } else if (value is DateTime) {
                  displayValue = _dateFormatter.format(value);
                } else {
                  displayValue = value.toString();
                }
              }
              return pw.Padding(
                padding: const pw.EdgeInsets.all(8),
                child: pw.Text(
                  displayValue,
                  style: const pw.TextStyle(fontSize: 9),
                ),
              );
            }).toList(),
          );
        }).toList(),
      ],
    );
  }

  pw.Widget _buildPDFFooter(DateTime now) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.center,
      children: [
        pw.Text(
          'Generated on ${_dateTimeFormatter.format(now)}',
          style: pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
        ),
      ],
    );
  }

  // Excel Export Methods
  Future<String?> exportToExcel({
    required String title,
    required String fileName,
    required List<Map<String, dynamic>> data,
    required List<String> headers,
    required List<String> columns,
    Map<String, dynamic>? summary,
  }) async {
    try {
      final excel = Excel.createExcel();
      excel.delete('Sheet1');
      final sheet = excel[title];

      int rowIndex = 0;

      // Title
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex))
          .value = TextCellValue('OctanePro - $title');
      final titleCell = sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex));
      titleCell.cellStyle = CellStyle(
        bold: true,
        fontSize: 16,
      );
      rowIndex++;

      // Date
      sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex))
              .value =
          TextCellValue('Generated: ${_dateFormatter.format(DateTime.now())}');
      rowIndex += 2;

      // Summary if provided
      if (summary != null) {
        summary.forEach((key, value) {
          sheet
              .cell(CellIndex.indexByColumnRow(
                  columnIndex: 0, rowIndex: rowIndex))
              .value = TextCellValue(key);
          final valueCell = sheet.cell(
              CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex));
          valueCell.value = TextCellValue(value is num
              ? _currencyFormatter.format(value)
              : value.toString());
          valueCell.cellStyle = CellStyle(bold: true);
          rowIndex++;
        });
        rowIndex++;
      }

      // Headers
      for (int i = 0; i < headers.length; i++) {
        final cell = sheet.cell(
            CellIndex.indexByColumnRow(columnIndex: i, rowIndex: rowIndex));
        cell.value = TextCellValue(headers[i]);
        cell.cellStyle = CellStyle(
          bold: true,
        );
      }
      rowIndex++;

      // Data rows
      for (var row in data) {
        for (int i = 0; i < columns.length; i++) {
          final value = row[columns[i]];
          if (value != null) {
            if (value is num) {
              sheet
                  .cell(CellIndex.indexByColumnRow(
                      columnIndex: i, rowIndex: rowIndex))
                  .value = IntCellValue(value.toInt());
            } else if (value is DateTime) {
              sheet
                  .cell(CellIndex.indexByColumnRow(
                      columnIndex: i, rowIndex: rowIndex))
                  .value = TextCellValue(_dateFormatter.format(value));
            } else {
              sheet
                  .cell(CellIndex.indexByColumnRow(
                      columnIndex: i, rowIndex: rowIndex))
                  .value = TextCellValue(value.toString());
            }
          }
        }
        rowIndex++;
      }

      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName.xlsx');
      final bytes = excel.encode();
      if (bytes != null) {
        await file.writeAsBytes(bytes);
        return file.path;
      }

      return null;
    } catch (e) {
      debugPrint('Excel Export Error: $e');
      return null;
    }
  }

  // Show export dialog
  Future<void> showExportDialog(
    BuildContext context, {
    required String title,
    required String fileName,
    required List<Map<String, dynamic>> data,
    required List<String> headers,
    required List<String> columns,
    Map<String, dynamic>? summary,
    String? subtitle,
  }) async {
    final format = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Options'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading:
                  const Icon(Icons.picture_as_pdf, color: AppTheme.errorRed),
              title: const Text('Export as PDF'),
              onTap: () => Navigator.pop(context, 'pdf'),
            ),
            ListTile(
              leading:
                  const Icon(Icons.table_chart, color: AppTheme.successGreen),
              title: const Text('Export as Excel'),
              onTap: () => Navigator.pop(context, 'excel'),
            ),
          ],
        ),
      ),
    );

    if (format == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    String? filePath;
    if (format == 'pdf') {
      filePath = await exportToPDF(
        title: title,
        fileName: fileName,
        data: data,
        headers: headers,
        columns: columns,
        summary: summary,
        subtitle: subtitle,
      );
    } else {
      filePath = await exportToExcel(
        title: title,
        fileName: fileName,
        data: data,
        headers: headers,
        columns: columns,
        summary: summary,
      );
    }

    if (context.mounted) {
      Navigator.pop(context); // Close loading dialog

      if (filePath != null) {
        await OpenFilex.open(filePath);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Exported successfully to ${format.toUpperCase()}'),
              backgroundColor: AppTheme.successGreen,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Export failed. Please try again.'),
              backgroundColor: AppTheme.errorRed,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }
}
