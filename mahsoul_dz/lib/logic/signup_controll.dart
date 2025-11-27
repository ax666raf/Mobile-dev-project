import 'package:flutter/material.dart';
import 'package:mahsoul_dz/views/models/customerSide/user_model.dart';
import 'package:mahsoul_dz/views/screens/customerSide/customer_form.dart'; // 👈 Import your target page

class SignUpController with ChangeNotifier {
  final User _user = User();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Getters
  User get user => _user;
  bool get agreeToTerms => _user.agreeToTerms;
  bool get subscribeToUpdates => _user.subscribeToUpdates;

  // Setters
  void setFullName(String value) {
    _user.fullName = value;
    notifyListeners();
  }

  void setEmail(String value) {
    _user.email = value;
    notifyListeners();
  }

  void setPassword(String value) {
    _user.password = value;
    notifyListeners();
  }

  void setConfirmPassword(String value) {
    _user.confirmPassword = value;
    notifyListeners();
  }

  void setAgreeToTerms(bool value) {
    _user.agreeToTerms = value;
    notifyListeners();
  }

  void setSubscribeToUpdates(bool value) {
    _user.subscribeToUpdates = value;
    notifyListeners();
  }

  // Business Logic
  Future<void> signUp(BuildContext context) async {
    if (!_user.agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please agree to Terms & Conditions')),
      );
      return;
    }

    if (formKey.currentState!.validate()) {
      try {
        // Simulate API call
        await Future.delayed(const Duration(seconds: 1));

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sign up successful! Redirecting...')),
        );

        // Wait briefly before navigating (optional)
        await Future.delayed(const Duration(milliseconds: 500));

        // 👇 Navigate to the Customer Form Page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CustomerFormScreen()),
        );
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Sign up failed: $e')));
      }
    }
  }

  // Validation methods
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value != _user.password) {
      return 'Passwords do not match';
    }
    return null;
  }

  // Cleanup
  @override
  void dispose() {
    // Dispose any resources if needed
  }
}
