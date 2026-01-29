import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';

import '../controllers/scan_doc_controller.dart';

class HistoryListScreen extends GetView<ScanDocController> {
  const HistoryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan History"), centerTitle: true),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => controller.scanDocuments(),
        label: const Text("Scan Document"),
        icon: const Icon(Icons.document_scanner),
      ),
      body: Obx(() {
        if (controller.scannedDocumentsList.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  "No scan history found",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: controller.scannedDocumentsList.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final doc = controller.scannedDocumentsList[index];
            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.picture_as_pdf, color: Colors.red),
                ),
                title: Text(
                  doc.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  DateFormat('MMM dd, yyyy - hh:mm a').format(doc.dateTime),
                  style: const TextStyle(fontSize: 12),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _showDeleteConfirmation(context, doc),
                ),
                onTap: () => _openDocument(doc.filePath),
              ),
            );
          },
        );
      }),
    );
  }

  void _openDocument(String path) async {
    final result = await OpenFilex.open(path);
    if (result.type != ResultType.done) {
      Get.snackbar(
        "Error",
        "Could not open file: ${result.message}",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _showDeleteConfirmation(BuildContext context, dynamic doc) {
    Get.dialog(
      AlertDialog(
        title: const Text("Delete Document"),
        content: const Text("Are you sure you want to delete this document?"),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              controller.deleteDocument(doc);
              Get.back();
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
