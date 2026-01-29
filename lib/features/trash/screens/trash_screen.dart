import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/trash_controller.dart';
import '../../history/models/scanned_document.dart';

class TrashScreen extends GetView<TrashController> {
  const TrashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Trash Bin"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever, color: Colors.red),
            onPressed: () => _showClearTrashConfirmation(context),
            tooltip: "Clear Trash",
          ),
        ],
      ),
      body: Obx(() {
        final list = controller.trashedDocuments;
        if (list.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.delete_outline, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text("Trash is empty", style: TextStyle(color: Colors.grey)),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: list.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final doc = list[index];
            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.picture_as_pdf, color: Colors.grey),
                title: Text(doc.name),
                subtitle: Text(
                  "Deleted: ${DateFormat('MMM dd, hh:mm a').format(doc.deletedAt!)}",
                  style: const TextStyle(fontSize: 12),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.restore, color: Colors.green),
                      onPressed: () => controller.restoreFromTrash(doc),
                      tooltip: "Restore",
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_forever, color: Colors.red),
                      onPressed: () =>
                          _showPermanentDeleteConfirmation(context, doc),
                      tooltip: "Delete Permanently",
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  void _showClearTrashConfirmation(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text("Clear Trash?"),
        content: const Text(
          "All files in the trash will be permanently deleted. This action cannot be undone.",
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              controller.clearAllTrash();
              Get.back();
            },
            child: const Text("Clear All", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showPermanentDeleteConfirmation(
    BuildContext context,
    ScannedDocument doc,
  ) {
    Get.dialog(
      AlertDialog(
        title: const Text("Delete Permanently?"),
        content: Text(
          "Are you sure you want to permanently delete \"${doc.name}\"?",
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              controller.permanentlyDelete(doc);
              Get.back();
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
