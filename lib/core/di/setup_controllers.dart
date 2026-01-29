import 'package:get/get.dart';
import '../utils/getx_helper.dart';
import '../../features/history/controllers/scan_doc_controller.dart';
import '../../features/search/controllers/search_controller.dart';
import '../../features/trash/controllers/trash_controller.dart';

Future<void> setupControllers() async {
  Get.getOrPutLazy(() => ScanDocController(), fenix: true);
  Get.getOrPutLazy(() => SearchHistoryController(), fenix: true);
  Get.getOrPutLazy(() => TrashController(), fenix: true);
}
