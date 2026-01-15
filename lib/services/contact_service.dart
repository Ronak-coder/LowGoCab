import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:lowgo_cab/utils/constants.dart';
import 'package:lowgo_cab/models/booking_model.dart';

class ContactService {
  /// Sends the booking data via EmailJS (100% Free - No Firebase Blaze plan needed)
  static Future<void> sendAutoEmail(Booking booking) async {
    const url = 'https://api.emailjs.com/api/v1.0/email/send';

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'service_id': AppConstants.emailJsServiceId,
        'template_id': AppConstants.emailJsTemplateId,
        'user_id': AppConstants.emailJsPublicKey,
        'template_params': {
          'user_name': booking.name,
          'user_mobile': booking.mobile,
          'package': booking.packageSelected,
          'from_loc': booking.fromLocation,
          'to_loc': booking.toLocation,
          'persons': booking.numberOfPersons.toString(),
          'reply_to': AppConstants.contactEmail,
        },
      }),
    );

    if (response.statusCode != 200) {
      print('DEBUG: EmailJS Error: ${response.body}');
      throw 'Failed to send automated email. Error: ${response.body}';
    } else {
      print('DEBUG: Automated email sent successfully via EmailJS!');
    }
  }

  /// Sends the same data via WhatsApp
  static Future<void> sendWhatsApp(Booking booking) async {
    final String message = booking.toWhatsAppMessage();
    final String phone = AppConstants.whatsappNumber
        .replaceAll('+', '')
        .replaceAll(' ', '');
    final Uri whatsappUri = Uri.parse(
      'https://wa.me/$phone?text=${Uri.encodeComponent(message)}',
    );

    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch WhatsApp';
    }
  }
}
