import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'ai_tool_home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: 'AIzaSyCiHirZF9rTj8SNRsV-2665hmRO4PB6u54',
          appId: '1:771285718310:android:4bd94901933f443acb5de7',
          messagingSenderId: '771285718310',
          projectId: 'abdsh-8ef9d',
          storageBucket: 'abdsh-8ef9d.firebasestorage.app')); // تهيئة Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'أدوات الذكاء الاصطناعي',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: AiToolHome(),
      ),
    );
  }
}
