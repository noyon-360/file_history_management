import 'package:get/get.dart';
import '../../history/controllers/scan_doc_controller.dart';
import '../../history/models/scanned_document.dart';

class SearchHistoryController extends GetxController {
  final ScanDocController _historyController = Get.find<ScanDocController>();
  final RxString searchQuery = "".obs;

  List<ScannedDocument> get filteredResults {
    final query = searchQuery.value.toLowerCase();
    final activeDocs = _historyController.scannedDocumentsList
        .where((doc) => !doc.isDeleted)
        .toList();

    if (query.isEmpty) {
      return activeDocs;
    }
    return activeDocs
        .where((doc) => doc.name.toLowerCase().contains(query))
        .toList();
  }

  void updateQuery(String value) {
    searchQuery.value = value;
  }

  void clearQuery() {
    searchQuery.value = "";
  }
}
