import 'package:crypto_tracker/views/app_route.dart';
import 'package:crypto_tracker/views/home.view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CrypTrack',
      initialRoute: AppRoutes.home,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: Colors.white,
      ),
      routes: {
        AppRoutes.home: (_) => const HomeView(title: 'CrypTrack'),
      },
    );
  }
}
