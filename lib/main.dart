import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magangsipatuh/pages/login.dart';
import 'package:magangsipatuh/pages/splash.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(const Duration(seconds: 3),), 
      builder:(context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return const SplashScreen();
        }else{
          return const GetMaterialApp(
            title: 'Login Aplikasi',
            debugShowCheckedModeBanner: false,
            home: LoginScreen(),
          );
        }
      },
      );
  }
}