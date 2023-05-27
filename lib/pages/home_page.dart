import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../constants/other_constants.dart';
import '../constants/api_key.dart';
import '../constants/validators.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _razorpay = Razorpay();
  final amountController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void initState() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  @override
  void dispose() {
    _razorpay.clear(); // Removes all listeners
    super.dispose();
  }

  void flutterToastMessage(String message){

    Fluttertoast.showToast(
      msg: message,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 4,
      backgroundColor: Colors.deepPurple.shade50,
      textColor: Colors.deepPurple,
      fontSize: 16.0,
    );
  }
  void _handlePaymentSuccess(PaymentSuccessResponse response) {

    flutterToastMessage('$flutterToastSuccessMessage: ${response.paymentId}');
    print("payment Successful"); // Terminal Message
  }

  void _handlePaymentError(PaymentFailureResponse response) {

    flutterToastMessage('$flutterToastFailureMessage: ${response.code} \n ${response.message}');
    print("Payment Failed"); // Terminal Message
  }

  void _handleExternalWallet(ExternalWalletResponse response) {

    flutterToastMessage('$flutterToastExternalWalletMessage: ${response.walletName}');
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text(kAppBarText, style: TextStyle(color: Colors.deepPurple),)),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: size.width / 5,
                    bottom: size.width / 10,
                    left: size.width / 20,
                    right: size.width / 20),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: kNameValidator,
                  controller: nameController,
                  decoration: const InputDecoration(hintText: kNameHintText),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: size.width / 10,
                    left: size.width / 20,
                    right: size.width / 20),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: kPhoneValidator,
                  controller: phoneController,
                  decoration: const InputDecoration(hintText: kPhoneHintText),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: size.width / 10,
                    left: size.width / 20,
                    right: size.width / 20),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: kEmailValidator,
                  controller: emailController,
                  decoration: const InputDecoration(hintText: kEmailHintText),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: size.width / 8,
                    left: size.width / 20,
                    right: size.width / 20),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: kDescriptionValidator,
                  controller: descriptionController,
                  decoration:
                      const InputDecoration(hintText: kDescriptionHintText),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: size.width / 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    kRupeeIcon,
                    SizedBox(
                      width: size.width / 2,
                      child: TextFormField(
                        style: kAmountTextSize,
                        textAlign: TextAlign.center,
                        keyboardType:
                            TextInputType.number, // Open numeric keypad
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: kAmountValidator,
                        controller: amountController,
                        decoration: const InputDecoration(
                          hintText: kAmountHintText,
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.w400
                          )
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: size.width / 20),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      minimumSize: Size(size.width  * 7 / 11, size.width / 8), // Button padding
                    ),
                    onPressed: () {
                      var options = {
                        'key': kApiKey,
                        'amount': (int.parse(amountController.text) * 100)
                            .toString(), //in the smallest currency sub-unit.
                        'name': nameController.text,
                        'description': descriptionController.text,
                        'timeout': 300, // in seconds
                        'prefill': {
                          'contact': phoneController.text,
                          'email': emailController.text
                        }
                      };
                      try{
                        _razorpay.open(options);
                      } catch(e) {
                        debugPrint(e.toString());
                      }
                    },
                    child: const Text(kMakePaymentText)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
