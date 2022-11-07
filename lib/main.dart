import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'screen_page/login_screen.dart';
import 'screen_page/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  //Thêm 2 dòng cho FireBase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShoesStore',
      theme: ThemeData(fontFamily: 'comfortaa'),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
