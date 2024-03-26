import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'home_page.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('hive_local_db');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Hive DB',
      theme: ThemeData(
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}