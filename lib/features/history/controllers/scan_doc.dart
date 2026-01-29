import 'package:flutx_core/flutx_core.dart';
import 'package:get/get.dart';
import 'package:simplest_document_scanner/simplest_document_scanner.dart';

class ScanDocController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    scanDocuments();
  }

  Future<void> scanDocuments() async {
    try {
      final document = await SimplestDocumentScanner.scanDocuments(
        options: const DocumentScannerOptions(
          maxPages: 8,
          returnJpegs: true,
          returnPdf: false,
          android: AndroidScannerOptions(scannerMode: DocumentScannerMode.full),
        ),
      );

      if (document == null) {
        DPrint.log('User cancelled the scan.');
        return;
      }

      for (final page in document.pages) {
        // Each page contains index + Uint8List bytes
        DPrint.log("Document: ${page.bytes}");
        // processPage(page.bytes);
      }

      if (document.hasPdf) {
        // savePdf(document.pdfBytes!);
      }
    } on DocumentScanException catch (error) {
      DPrint.log("Document Scan Error: ${error.reason}");
      // handleScanFailure(error.reason, error.message);
    }
  }
}
