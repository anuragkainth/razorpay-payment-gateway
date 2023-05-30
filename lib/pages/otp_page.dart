import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:payment_gateway/pages/phone_page.dart';
import 'package:pinput/pinput.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../constants/text_constants.dart';
import '../constants/widget_constants.dart';


class OtpVerifyPage extends StatefulWidget {
  const OtpVerifyPage({Key? key}) : super(key: key);

  @override
  State<OtpVerifyPage> createState() => _OtpVerifyPageState();
}

class _OtpVerifyPageState extends State<OtpVerifyPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  var code = "";

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: kBackArrowIcon,
        ),
        elevation: 0,
      ),
      body: Container(
        margin: EdgeInsets.only(left: size.width / 20, right: size.width / 20),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: size.width / 26),
                child: Text(
                  kOtpWelcomeText,
                  style: TextStyle(fontSize: size.width / 17, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: size.width / 32),
                child: Text(
                  kOtpDescription,
                  style: TextStyle(
                    fontSize: size.width / 26,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: size.width / 20),
                child: Pinput(
                  length: 6,
                  onChanged: (value) {
                    code = value;
                  },
                  showCursor: true,
                  onCompleted: (pin) => print(pin),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: size.width / 8.5,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () async {
                      try {
                        PhoneAuthCredential credential =
                            PhoneAuthProvider.credential(
                                verificationId: PhonePage.verify, smsCode: code);
                        // Sign the user in (or link) with the credential
                        await auth.signInWithCredential(credential);
                        Fluttertoast.showToast(
                          msg: "Welcome User",
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 4,
                          backgroundColor: Colors.deepPurple.shade50,
                          textColor: Colors.deepPurple,
                          fontSize: 16.0,
                        );
                        if(context.mounted){
                          //to determine whether the context is still valid before interacting with it
                          Navigator.pushNamedAndRemoveUntil(context, "home", (route) => false);
                        }
                      } catch (e) {
                        print(e.toString());
                      }
                    },
                    child: const Text(kOptScreenButtonText)),
              ),
              Row(
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          'phone',
                          (route) => false,
                        );
                      },
                      child: const Text(
                        kOtpScreenChangePhoneText,
                        style: TextStyle(color: Colors.black),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
