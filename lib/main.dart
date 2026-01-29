import 'package:file_history_management/core/config/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'features/history/screens/history_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'File History Management',
      theme: AppTheme.dark,
      home: const HistoryListScreen(),
    );
  }
}
