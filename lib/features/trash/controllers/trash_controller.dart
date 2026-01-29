import 'package:get/get.dart';
import '../../history/controllers/scan_doc_controller.dart';
import '../../history/models/scanned_document.dart';

class TrashController extends GetxController {
  final ScanDocController _historyController = Get.find<ScanDocController>();

  // Use a computed list of trashed documents
  List<ScannedDocument> get trashedDocuments {
    final list = _historyController.scannedDocumentsList
        .where((doc) => doc.isDeleted)
        .toList();
    list.sort(
      (a, b) => (b.deletedAt ?? DateTime.now()).compareTo(
        a.deletedAt ?? DateTime.now(),
      ),
    );
    return list;
  }

  Future<void> moveToTrash(ScannedDocument doc) async {
    final updatedDoc = doc.copyWith(deletedAt: DateTime.now());
    await _historyController.updateDocument(updatedDoc);
  }

  Future<void> restoreFromTrash(ScannedDocument doc) async {
    final updatedDoc = doc.copyWith(clearDeletedAt: true);
    await _historyController.updateDocument(updatedDoc);
  }

  Future<void> permanentlyDelete(ScannedDocument doc) async {
    await _historyController.deleteDocument(doc);
  }

  Future<void> clearAllTrash() async {
    final docsToClear = List<ScannedDocument>.from(trashedDocuments);
    for (var doc in docsToClear) {
      await _historyController.deleteDocument(doc);
    }
  }
}
