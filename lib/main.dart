// main.dart

import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:provider/provider.dart';

import 'package:machine_basil/views/Home/home.dart';
import 'constants/AppPages.dart';
import 'constants/theme.dart';

// Define the WebSocket URL
const String webSocketUrl = 'ws://localhost:8081';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Basil Machine',
      theme: ThemeClass.buildTheme(context),
      initialRoute: AppPages.HomePage,
      getPages: [
        GetPage(name: AppPages.HomePage, page: () => const HomeScreen())
      ],
    );
  }
}
