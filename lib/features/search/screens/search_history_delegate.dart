import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import '../controllers/search_controller.dart';
import '../../history/models/scanned_document.dart';

class SearchHistoryDelegate extends SearchDelegate<ScannedDocument?> {
  final SearchHistoryController controller =
      Get.find<SearchHistoryController>();

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          controller.clearQuery();
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        controller.clearQuery();
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    controller.updateQuery(query);
    return _buildList();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    controller.updateQuery(query);
    return _buildList();
  }

  Widget _buildList() {
    return Obx(() {
      final list = controller.filteredResults;
      if (list.isEmpty) {
        return Center(
          child: Text(
            query.isEmpty
                ? "Search for documents"
                : "No results for \"$query\"",
            style: const TextStyle(color: Colors.grey),
          ),
        );
      }

      return ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: list.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final doc = list[index];
          return ListTile(
            leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
            title: Text(doc.name),
            subtitle: Text(DateFormat('MMM dd, yyyy').format(doc.dateTime)),
            onTap: () async {
              await OpenFilex.open(doc.filePath);
            },
          );
        },
      );
    });
  }
}
