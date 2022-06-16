import 'package:crypto_tracker/app_route.dart';
import 'package:crypto_tracker/controllers/auth_controller.dart';
import 'package:crypto_tracker/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final AuthController authController =
      Get.put<AuthController>(AuthController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CrypTrack',
      defaultTransition: Transition.rightToLeft,
      initialRoute: AppRoutes.home,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: Colors.white,
      ),
      getPages: AppRoutes.routes,
    );
  }
}
