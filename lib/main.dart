import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  final auth = await Hive.openBox('auth');
  await Hive.openBox('posyandu');
  await Hive.openBox('profil');

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Posyandu App",
      initialRoute:
          auth.containsKey('username') ? AppPages.HOME : AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
