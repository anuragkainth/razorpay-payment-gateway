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

  // Creating razorpay's object
  final _razorpay = Razorpay();

  // Creating all Text Controllers
  final amountController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  // Event Listeners for communication
  void initState() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  @override
  // Clearing the object data
  void dispose() {
    _razorpay.clear(); // Removes all listeners
    super.dispose();
  }

  // Function to display toast messages
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
  // Function that handle's Payment's Success
  void _handlePaymentSuccess(PaymentSuccessResponse response) {

    flutterToastMessage('$flutterToastSuccessMessage: ${response.paymentId}');
    print("payment Successful"); // Terminal Message
  }

  // Function handle's Payment Failure
  void _handlePaymentError(PaymentFailureResponse response) {

    flutterToastMessage('$flutterToastFailureMessage: ${response.code} \n ${response.message}');
    print("Payment Failed"); // Terminal Message
  }

  // Function handle's External Wallet
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
              // Name Text From Field
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
              // Phone Number Text Form Field
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
              // Email Text From Field
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
              // Description Text Form Field
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
              // Amount Text Form Field
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
              // Make Payment Button at Bottom of Screen
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
                      // Data of current payment to be passed to razorpay object
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
                      // Accessing razorpay gateway
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
