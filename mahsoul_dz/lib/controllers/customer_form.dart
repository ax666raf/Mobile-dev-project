import 'package:flutter/material.dart';
import 'package:mahsoul_dz/pages/main_navigation.dart'; 

class CustomerFormController extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  String? fullName;
  String? phoneNumber;
  String? address;
  String? city;
  String? postalCode;

  void setFullName(String value) {
    fullName = value;
    notifyListeners();
  }

  void setPhoneNumber(String value) {
    phoneNumber = value;
    notifyListeners();
  }

  void setAddress(String value) {
    address = value;
    notifyListeners();
  }

  void setCity(String value) {
    city = value;
    notifyListeners();
  }

  void setPostalCode(String value) {
    postalCode = value;
    notifyListeners();
  }

  Future<void> submitForm(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Profile Completed Successfully!"),
          backgroundColor: Color(0xFF4CAF50),
        ),
      );

      await Future.delayed(const Duration(milliseconds: 300));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainNavigation()),
      );
    }
  }
}
