import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class PhoneLauncher {
  /// Launch phone call
  /// Returns true if successful, false otherwise
  static Future<bool> makePhoneCall(String? phoneNumber) async {
    if (phoneNumber == null || phoneNumber.isEmpty || phoneNumber.trim().isEmpty) {
      return false;
    }

    // Remove any non-digit characters except +
    String cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    
    // If number doesn't start with +, assume it's a local number
    if (!cleanNumber.startsWith('+')) {
      // For Algeria, add +213 if it's a local number
      if (cleanNumber.startsWith('0')) {
        cleanNumber = '+213${cleanNumber.substring(1)}';
      } else if (!cleanNumber.startsWith('213')) {
        cleanNumber = '+213$cleanNumber';
      } else {
        cleanNumber = '+$cleanNumber';
      }
    }

    final Uri phoneUri = Uri.parse('tel:$cleanNumber');
    
    try {
      if (await canLaunchUrl(phoneUri)) {
        return await launchUrl(phoneUri);
      } else {
        print('Cannot launch phone call: $phoneUri');
        return false;
      }
    } catch (e) {
      print('Error launching phone call: $e');
      return false;
    }
  }

  /// Launch WhatsApp with message
  /// Returns true if successful, false otherwise
  static Future<bool> launchWhatsApp(String? phoneNumber, {String? message}) async {
    if (phoneNumber == null || phoneNumber.isEmpty || phoneNumber.trim().isEmpty) {
      return false;
    }

    // Remove any non-digit characters except +
    String cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    
    // If number doesn't start with +, assume it's a local number
    if (!cleanNumber.startsWith('+')) {
      // For Algeria, add +213 if it's a local number
      if (cleanNumber.startsWith('0')) {
        cleanNumber = '+213${cleanNumber.substring(1)}';
      } else if (!cleanNumber.startsWith('213')) {
        cleanNumber = '+213$cleanNumber';
      } else {
        cleanNumber = '+$cleanNumber';
      }
    }

    // Remove + from WhatsApp URL (WhatsApp doesn't need it)
    String whatsappNumber = cleanNumber.replaceFirst('+', '');
    
    // Encode message if provided
    String encodedMessage = message != null ? Uri.encodeComponent(message) : '';
    String whatsappUrl = 'https://wa.me/$whatsappNumber';
    if (encodedMessage.isNotEmpty) {
      whatsappUrl += '?text=$encodedMessage';
    }

    final Uri whatsappUri = Uri.parse(whatsappUrl);
    
    try {
      if (await canLaunchUrl(whatsappUri)) {
        return await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
      } else {
        print('Cannot launch WhatsApp: $whatsappUri');
        return false;
      }
    } catch (e) {
      print('Error launching WhatsApp: $e');
      return false;
    }
  }

  /// Show error snackbar if phone/WhatsApp launch fails
  static void showErrorSnackbar(BuildContext context, String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Unable to $action. Phone number is not available. Please ask the user to add their phone number in their profile.',
        ),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  /// Show success message (optional)
  static void showSuccessSnackbar(BuildContext context, String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening $action...'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

