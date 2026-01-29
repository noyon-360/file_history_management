import '/core/utils/getx_helper.dart';
import '/features/history/controllers/scan_doc_controller.dart';
import 'package:get/get.dart';

Future<void> setupControllers() async {
  Get.getOrPutLazy(() => ScanDocController());
}
