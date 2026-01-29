import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutx_core/flutx_core.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simplest_document_scanner/simplest_document_scanner.dart'
    as scanner;
import 'package:crypto/crypto.dart';
import '../models/scanned_document.dart';
import '../../../core/services/hive_storage_service.dart';

class ScanDocController extends GetxController {
  final _hiveService = HiveStorageService();
  final RxList<ScannedDocument> scannedDocumentsList = <ScannedDocument>[].obs;
  final RxBool isSaving = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadDocuments();
  }

  Future<void> loadDocuments() async {
    final docsMap = _hiveService.getAllDocuments();
    final List<ScannedDocument> allDocs = [];

    for (final e in docsMap) {
      final doc = ScannedDocument.fromMap(e);
      // Verify file exists on disk
      if (await File(doc.filePath).exists()) {
        allDocs.add(doc);
      } else {
        // Cleanup registry if file is missing
        await _hiveService.deleteDocument(doc.id);
      }
    }

    scannedDocumentsList.value = allDocs;
    scannedDocumentsList.sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }

  List<ScannedDocument> get activeDocuments =>
      scannedDocumentsList.where((doc) => !doc.isDeleted).toList();

  List<ScannedDocument> get favoriteDocuments => scannedDocumentsList
      .where((doc) => !doc.isDeleted && doc.isFavorite)
      .toList();

  Future<void> updateDocument(ScannedDocument doc) async {
    await _hiveService.updateDocument(doc.toMap());
    await loadDocuments();
  }

  Future<void> toggleFavorite(ScannedDocument doc) async {
    final updatedDoc = doc.copyWith(isFavorite: !doc.isFavorite);
    await updateDocument(updatedDoc);
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
        _showNameInputDialog(document.pdfBytes!);
      }
    } on scanner.DocumentScanException catch (error) {
      DPrint.log("Document Scan Error: ${error.reason}");
    } catch (e) {
      DPrint.log("General Error: $e");
    }
  }

  void _showNameInputDialog(List<int> pdfBytes) {
    if (isSaving.value) return;

    final TextEditingController nameController = TextEditingController(
      text: "Scan ${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}",
    );

    Get.dialog(
      AlertDialog(
        title: const Text("Save Document"),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: "Document Name",
            hintText: "Enter name here...",
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              Get.back();
              _saveDocument(pdfBytes, customName: nameController.text.trim());
            },
            child: const Text("Save"),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  Future<void> _saveDocument(List<int> pdfBytes, {String? customName}) async {
    if (isSaving.value) return;

    try {
      isSaving.value = true;

      // Calculate hash for duplicate detection
      final hash = sha256.convert(pdfBytes).toString();

      // Check for duplicates
      final isDuplicate = scannedDocumentsList.any(
        (doc) => doc.contentHash == hash,
      );
      if (isDuplicate) {
        _showDuplicateWarning();
        isSaving.value = false;
        return;
      }

      final directory = await getApplicationDocumentsDirectory();
      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final String fileName = "Scan_$timestamp.pdf";
      final String filePath = "${directory.path}/$fileName";

      final File file = File(filePath);
      await file.writeAsBytes(pdfBytes);
      final int size = await file.length();

      final newDoc = ScannedDocument(
        id: timestamp,
        name: (customName == null || customName.trim().isEmpty)
            ? "Document $timestamp"
            : customName,
        filePath: filePath,
        dateTime: DateTime.now(),
        fileSize: size,
        contentHash: hash,
      );

      await _hiveService.saveDocument(newDoc.toMap());
      await loadDocuments();
      DPrint.log("Document saved successfully at $filePath");
    } catch (e) {
      DPrint.log("Error saving document: $e");
    } finally {
      isSaving.value = false;
    }
  }

  void _showDuplicateWarning() {
    Get.snackbar(
      "Duplicate Document",
      "This document has already been saved in your history.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange.withOpacity(0.8),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
    );
  }

  Future<void> deleteDocument(ScannedDocument doc) async {
    try {
      final file = File(doc.filePath);
      if (await file.exists()) {
        await file.delete();
      }
      await _hiveService.deleteDocument(doc.id);
      await loadDocuments();
    } catch (e) {
      DPrint.log("Error deleting document: $e");
    }
  }
}
