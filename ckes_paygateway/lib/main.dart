import 'package:ckes_paygateway/screens/auth_client.dart';
import 'package:ckes_paygateway/screens/login_screen.dart';
import 'package:ckes_paygateway/screens/registration_screen.dart';
import 'package:ckes_paygateway/screens/zkp_auth.dart';
import 'package:ckes_paygateway/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


void main() {
  //  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
  //     statusBarColor: Colors.transparent,
  //     // statusBarIconBrightness: Brightness.light,
  //     statusBarIconBrightness: Brightness.dark
  //   ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.lightTheme,
      // home: const LoginScreen(),
      // home: const ZkpAuthScreen(),
      // home: const ZKPAuthPage(),
      home: const RegistrationScreen(),
    );
  }
}
