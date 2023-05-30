import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:payment_gateway/pages/home_page.dart';
import 'package:payment_gateway/pages/phone_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError){
            return const Center(child: Text('Something went wrong'));
          } else if(snapshot.hasData){
            return const HomePage();
          } else {
            return const PhonePage();
          }
        },
      ),
    );
  }
}


