import 'package:flutx_core/core/debug_print.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveStorageService {
  // Private constructor
  HiveStorageService._internal();

  // Singleton instance
  static final HiveStorageService _instance = HiveStorageService._internal();

  // Public factory constructor
  factory HiveStorageService() => _instance;

  // Default box name (you can change or make it configurable)
  static const String _defaultBox = 'app_box';
  static const String _docsKey = 'scanned_documents';

  late Box _box;

  /// Initialize Hive and open the default box
  /// Call this in main() before runApp()
  static Future<void> init() async {
    await Hive.initFlutter();

    // Optional: Register adapters here if using custom objects
    // Hive.registerAdapter(UserModelAdapter());
    // Hive.registerAdapter(SettingsAdapter());

    final instance = HiveStorageService();
    instance._box = await Hive.openBox(_defaultBox);
    DPrint.log("HiveStorageService initialized successfully");
  }

  // Helper to get the box
  Box get box => _box;

  /// Store any value by key (String, int, bool, double, List, Map, etc.)
  Future<void> put(String key, dynamic value) async {
    await _box.put(key, value);
    DPrint.log("Hive: Stored [$key] = $value");
  }

  /// Retrieve value by key with optional default
  T get<T>(String key, {T? defaultValue}) {
    final value = _box.get(key, defaultValue: defaultValue);
    DPrint.log("Hive: Retrieved [$key] = $value");
    return value;
  }

  /// Check if key exists
  bool containsKey(String key) => _box.containsKey(key);

  /// Delete single key
  Future<void> delete(String key) async {
    await _box.delete(key);
    DPrint.log("Hive: Deleted key [$key]");
  }

  /// Delete multiple keys
  Future<void> deleteMany(List<String> keys) async {
    await _box.deleteAll(keys);
    DPrint.log("Hive: Deleted keys: $keys");
  }

  /// Clear entire box
  Future<void> clear() async {
    await _box.clear();
    DPrint.log("Hive: Cleared all data");
  }

  /// Scanned Documents specific methods
  Future<void> saveDocument(Map<String, dynamic> docMap) async {
    final List<dynamic> currentDocs = _box.get(_docsKey, defaultValue: []);
    currentDocs.add(docMap);
    await _box.put(_docsKey, currentDocs);
    DPrint.log("Hive: Saved new document");
  }

  List<Map<String, dynamic>> getAllDocuments() {
    final List<dynamic> rawDocs = _box.get(_docsKey, defaultValue: []);
    return rawDocs.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  Future<void> updateDocument(Map<String, dynamic> docMap) async {
    final List<dynamic> currentDocs = _box.get(_docsKey, defaultValue: []);
    final index = currentDocs.indexWhere(
      (element) => element['id'] == docMap['id'],
    );
    if (index != -1) {
      currentDocs[index] = docMap;
      await _box.put(_docsKey, currentDocs);
      DPrint.log("Hive: Updated document with id ${docMap['id']}");
    }
  }

  Future<void> deleteDocument(String id) async {
    final List<dynamic> currentDocs = _box.get(_docsKey, defaultValue: []);
    currentDocs.removeWhere((element) => element['id'] == id);
    await _box.put(_docsKey, currentDocs);
    DPrint.log("Hive: Deleted document with id $id");
  }

  /// Close all boxes (call on app close if needed)
  static Future<void> close() async {
    await Hive.close();
    DPrint.log("Hive: All boxes closed");
  }
}
