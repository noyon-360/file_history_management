import 'package:flutter/widgets.dart';
import 'package:flutx_core/flutx_core.dart';

import '../services/hive_storage_service.dart';
import '../di/service_locator.dart';

class AppInitializer {
  static Future<void> initializeApp() async {
    WidgetsFlutterBinding.ensureInitialized();

    await HiveStorageService.init();
    try {
      await setupServiceLocator();
      DPrint.log("Service Locator Setup Completed");
    } catch (err) {
      DPrint.log("Error in Service Locator Setup: $err");
    }
  }
}
