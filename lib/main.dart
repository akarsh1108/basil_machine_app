// main.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:machine_basil/controller/ValueNotifier.dart';
import 'package:machine_basil/views/LocalRecipes/LocalRecipe.dart';
import 'package:machine_basil/views/Refilling/refillingContainer.dart';
import 'package:machine_basil/views/utilities/utilities.dart';
import 'package:provider/provider.dart';

import 'package:machine_basil/views/Home/home.dart';
import 'constants/AppPages.dart';
import 'constants/theme.dart';
import 'controller/MenuController.dart';

// Define the WebSocket URL
const String webSocketUrl = 'ws://localhost:8081';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  Get.put(MenuControllers());
  await loadInitialQuantities();
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
        GetPage(name: AppPages.HomePage, page: () => const HomeScreen()),
        GetPage(name: AppPages.Replenishment, page: ()=> const RefillingLiquid()),
        GetPage(name: AppPages.LocalRecipes, page: ()=> const LocalRecipeScreen()),
        GetPage(name: AppPages.Utilities, page: ()=> const UtilitiesScreen())
      ],
    );
  }
}
