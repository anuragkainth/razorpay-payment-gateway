import 'package:flutter/material.dart';
import 'package:payment_gateway/pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:payment_gateway/pages/otp_page.dart';
import 'package:payment_gateway/pages/phone_page.dart';

Future main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'phone',
      routes: {
        'phone' : (context) => const PhonePage(),
        'otp' : (context) => const OtpVerifyPage(),
        'home' : (context) => const HomePage()
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}

