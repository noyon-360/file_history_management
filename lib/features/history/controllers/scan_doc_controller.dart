import 'dart:io';

import 'package:flutx_core/flutx_core.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simplest_document_scanner/simplest_document_scanner.dart'
    as scanner;

import '../../../core/models/scanned_document.dart';
import '../../../core/services/hive_storage_service.dart';

class ScanDocController extends GetxController {
  final _hiveService = HiveStorageService();
  final RxList<ScannedDocument> scannedDocumentsList = <ScannedDocument>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadDocuments();
  }

  void loadDocuments() {
    final docsMap = _hiveService.getAllDocuments();
    scannedDocumentsList.value = docsMap
        .map((e) => ScannedDocument.fromMap(e))
        .toList();
    // Sort by date descending
    scannedDocumentsList.sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }

  Future<void> scanDocuments() async {
    try {
      final document = await scanner.SimplestDocumentScanner.scanDocuments(
        options: const scanner.DocumentScannerOptions(
          maxPages: 8,
          returnJpegs: true,
          returnPdf: true,
          android: scanner.AndroidScannerOptions(
            scannerMode: scanner.DocumentScannerMode.full,
          ),
        ),
      );

      if (document == null) {
        DPrint.log('User cancelled the scan.');
        return;
      }

      if (document.hasPdf && document.pdfBytes != null) {
        await _saveDocument(document.pdfBytes!);
      } else {
        DPrint.log("No PDF generated from scan.");
      }
    } on scanner.DocumentScanException catch (error) {
      DPrint.log("Document Scan Error: ${error.reason}");
    } catch (e) {
      DPrint.log("General Error: $e");
    }
  }

  Future<void> _saveDocument(List<int> pdfBytes) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final String fileName = "Scan_$timestamp.pdf";
      final String filePath = "${directory.path}/$fileName";

      final File file = File(filePath);
      await file.writeAsBytes(pdfBytes);

      final newDoc = ScannedDocument(
        id: timestamp,
        name: "Document $timestamp",
        filePath: filePath,
        dateTime: DateTime.now(),
      );

      await _hiveService.saveDocument(newDoc.toMap());
      loadDocuments(); // Refresh the list
      DPrint.log("Document saved successfully at $filePath");
    } catch (e) {
      DPrint.log("Error saving document: $e");
    }
  }

  Future<void> deleteDocument(ScannedDocument doc) async {
    try {
      final file = File(doc.filePath);
      if (await file.exists()) {
        await file.delete();
      }
      await _hiveService.deleteDocument(doc.id);
      loadDocuments();
    } catch (e) {
      DPrint.log("Error deleting document: $e");
    }
  }
}
