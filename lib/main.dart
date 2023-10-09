import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_app_fluter/utils/push_screen.dart';

import 'screen_page/home_screen.dart';

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
      navigatorKey: navKey,
      theme: ThemeData(primarySwatch: Colors.pink, fontFamily: 'comfortaa'),
      builder: BotToastInit(), //1. call BotToastInit
      navigatorObservers: [BotToastNavigatorObserver()],
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
