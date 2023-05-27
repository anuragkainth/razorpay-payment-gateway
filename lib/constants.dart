import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

// API KEY
const String kApiKey = "rzp_test_LTEgszue0u4eFC";

// ICONS
const kRupeeIcon = Icon(
  Icons.currency_rupee,
  color: Colors.deepPurple,
  size: 30,
);

// TEXT FORM FIELDS VALIDATORS
String? Function(String?)? kAmountValidator = (value) {
  if (value!.isEmpty) {
    return 'Please enter an amount';
  }
  if (double.tryParse(value) == null) {
    return 'Please enter a valid amount';
  }
  if (double.parse(value) <= 0) {
    return 'Amount must be greater than zero';
  }
  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
    return 'Amount should only contain digits';
  }
  return null; // Return null for no validation errors
};

String? Function(String?)? kDescriptionValidator = (value) {
  if (value!.isEmpty) {
    return 'Please enter a description';
  }
  if (value.length < 10) {
    return 'Description should be at least 10 characters long';
  }
  return null; // Return null for no validation errors
};

String? Function(String?)? kEmailValidator = (email) =>
    email != null && !EmailValidator.validate(email)
        ? 'Enter a valid email'
        : null;

String? Function(String?)? kPhoneValidator = (value) {
  if (value!.isEmpty) {
    return 'Please enter a phone number';
  }
  if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
    return 'Please enter a valid 10-digit phone number';
  }
  return null; // Return null for no validation errors
};

String? Function(String?)? kNameValidator = (value) {
  if (value!.isEmpty) {
    return 'Please enter your name';
  }
  if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
    return 'Please enter a valid name';
  }
  return null; // Return null for no validation errors
};

// CONST TEXTS
const kAppBarText = 'IncraSoft Payment Gateway';
const kNameHintText = 'Enter Your Name';
const kPhoneHintText = 'Enter Phone Number';
const kEmailHintText = 'Enter your Email';
const kDescriptionHintText = 'Enter Description';
const kAmountHintText = 'Enter Amount';

// TEXT SIZE
const kAmountTextSize = TextStyle(
  fontSize: 22.0,
);
