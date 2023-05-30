import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:payment_gateway/constants/text_constants.dart';

class PhonePage extends StatefulWidget {
  const PhonePage({Key? key}) : super(key: key);

  static String verify = "";

  @override
  State<PhonePage> createState() => _PhonePageState();
}

class _PhonePageState extends State<PhonePage> {
  TextEditingController countryController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    countryController.text = kCountryCode;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: size.width / 26),
                child: Text(
                  kWelcomeText,
                  style: TextStyle(fontSize: size.width / 17, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: size.width / 32),
                child: Text(
                  kWelcomeDescription,
                  style: TextStyle(
                    fontSize: size.width / 26,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: size.width / 20),
                child: Container(
                  height: size.width / 8,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: size.width / 40,
                      ),
                      SizedBox(
                        width: size.width / 12,
                        child: TextField(
                          controller: countryController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Text(
                        kPhoneTextFieldDivider,
                        style: TextStyle(fontSize: size.width / 13, color: Colors.grey),
                      ),
                      SizedBox(
                        width: size.width / 45,
                      ),
                      Expanded(
                          child: TextField(
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: kPhoneBoxHintText,
                            ),
                          ))
                    ],
                  ),
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
                      await FirebaseAuth.instance.verifyPhoneNumber(
                        phoneNumber: countryController.text+phoneController.text,
                        verificationCompleted: (PhoneAuthCredential credential) {},
                        verificationFailed: (FirebaseAuthException e) {},
                        codeSent: (String verificationId, int? resendToken) {
                          PhonePage.verify = verificationId;
                          Navigator.pushNamed(context, "otp");
                        },
                        codeAutoRetrievalTimeout: (String verificationId) {},
                      );
                      // Navigator.pushNamed(context, 'verify');
                    },
                    child: const Text(kPhoneScreenButtonText)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
