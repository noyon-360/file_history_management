import 'package:file_history_management/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';

import '../controllers/scan_doc_controller.dart';
import '../../search/screens/search_history_delegate.dart';
import '../../trash/screens/trash_screen.dart';
import '../../trash/controllers/trash_controller.dart';

class HistoryListScreen extends GetView<ScanDocController> {
  const HistoryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Welcome to Scanner"),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => showSearch(
                context: context,
                delegate: SearchHistoryDelegate(),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => Get.to(() => const TrashScreen()),
            ),
          ],
          bottom: const TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            dividerColor: Colors.transparent,
            tabs: [
              Tab(text: "All Docs"),
              Tab(text: "Favorites"),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => controller.scanDocuments(),
          label: const Text("Scan Document"),
          icon: const Icon(Icons.document_scanner),
        ),
        body: TabBarView(
          children: [
            _buildDocumentList(isFavorites: false),
            _buildDocumentList(isFavorites: true),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentList({required bool isFavorites}) {
    return Obx(() {
      final list = isFavorites
          ? controller.favoriteDocuments
          : controller.activeDocuments;

      if (list.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.history, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text("No documents found", style: TextStyle(color: Colors.grey)),
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
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                DateFormat('MMM dd, yyyy - hh:mm a').format(doc.dateTime),
                style: const TextStyle(fontSize: 12),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      doc.isFavorite ? Icons.star : Icons.star_border,
                      color: doc.isFavorite
                          ? AppColors.primaryWhite
                          : AppColors.primaryGray,
                    ),
                    onPressed: () => controller.toggleFavorite(doc),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'delete') {
                        _showDeleteConfirmation(Get.context!, doc);
                      } else if (value == 'details') {
                        _showDetails(Get.context!, doc);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'details',
                        child: Text("Details"),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text(
                          "Move to Trash",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              onTap: () => _openDocument(doc.filePath),
            ),
          );
        },
      );
    });
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

  void _showDetails(BuildContext context, dynamic doc) {
    final String sizeStr = (doc.fileSize / 1024).toStringAsFixed(2) + " KB";
    Get.dialog(
      AlertDialog(
        title: const Text("Document Details"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailItem("Name", doc.name),
            _detailItem("Type", doc.extension),
            _detailItem("Size", sizeStr),
            _detailItem(
              "Created",
              DateFormat('MMM dd, yyyy - hh:mm a').format(doc.dateTime),
            ),
            _detailItem("Path", doc.filePath),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Close")),
        ],
      ),
    );
  }

  Widget _detailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          Text(value, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, dynamic doc) {
    Get.dialog(
      AlertDialog(
        title: const Text("Move to Trash?"),
        content: const Text("This document will be moved to the trash bin."),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              Get.find<TrashController>().moveToTrash(doc);
              Get.back();
            },
            child: const Text(
              "Move to Trash",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
