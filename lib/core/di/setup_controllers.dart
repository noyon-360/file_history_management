import 'package:file_history_management/core/utils/getx_helper.dart';
import 'package:file_history_management/features/history/controllers/scan_doc_controller.dart';
import 'package:get/get.dart';

Future<void> setupControllers() async {
  Get.getOrPutLazy(() => ScanDocController(), fenix: true);
}
