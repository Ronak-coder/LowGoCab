import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:lowgo_cab/utils/constants.dart';
import 'package:lowgo_cab/models/booking_model.dart';

class ContactService {
  /// Helper to send email via Brevo API
  static Future<void> _sendBrevoEmail({
    required String toName,
    required String toEmail,
    required String subject,
    required String htmlContent,
  }) async {
    const url = 'https://api.brevo.com/v3/smtp/email';

    // Check if API key is set
    if (AppConstants.brevoApiKey.contains('REPLACE')) {
      throw 'Brevo API Key not configured. Please add your key in utils/constants.dart';
    }

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'api-key': AppConstants.brevoApiKey,
          'Content-Type': 'application/json',
          'accept': 'application/json',
        },
        body: json.encode({
          'sender': {
            'name': AppConstants.appName,
            'email': AppConstants.contactEmail, // Must be verified in Brevo
          },
          'to': [
            {'email': toEmail, 'name': toName},
          ],
          'subject': subject,
          'htmlContent': htmlContent,
        }),
      );

      if (response.statusCode != 201) {
        print('Brevo Error: ${response.body}');
        throw 'Failed to send email. Status: ${response.statusCode}';
      }
    } catch (e) {
      print('Email Sending Error: $e');
      rethrow;
    }
  }

  /// Sends Contact Form Email (To Admin + Auto-Reply to User)
  static Future<void> sendContactEmail({
    required String name,
    required String email,
    required String phone,
    required String message,
  }) async {
    // 1. Send to Admin
    final String adminContent =
        '''
      <html><body>
        <h2>New Contact Inquiry</h2>
        <p><strong>Name:</strong> $name</p>
        <p><strong>Email:</strong> $email</p>
        <p><strong>Phone:</strong> $phone</p>
        <p><strong>Message:</strong><br>$message</p>
      </body></html>
    ''';

    await _sendBrevoEmail(
      toName: 'Admin',
      toEmail: AppConstants.contactEmail,
      subject: '[ADMIN] New Inquiry from $name',
      htmlContent: adminContent,
    );

    // 2. Auto-Reply to User
    if (email.isNotEmpty) {
      final String userContent =
          '''
        <html><body>
          <h2>Thank You for Contacting Us!</h2>
          <p>Hi $name,</p>
          <p>We have received your message and will get back to you shortly.</p>
          <hr>
          <p><strong>Your Message:</strong><br>$message</p>
          <br>
          <p>Best Regards,<br>${AppConstants.appName} Team</p>
        </body></html>
      ''';

      // Fire and forget auto-reply to not block UI
      _sendBrevoEmail(
        toName: name,
        toEmail: email,
        subject: 'We received your message - ${AppConstants.appName}',
        htmlContent: userContent,
      ).catchError((e) => print('Auto-reply failed: $e'));
    }
  }

  /// Sends Feedback Email (To Admin + Auto-Reply to User)
  static Future<void> sendFeedbackEmail({
    required String name,
    required String email,
    required String phone,
    required int rating,
    required String feedback,
  }) async {
    // 1. Send to Admin
    final String adminContent =
        '''
      <html><body>
        <h2>New Feedback Received ($rating/5)</h2>
        <p><strong>Name:</strong> $name</p>
        <p><strong>Email:</strong> $email</p>
        <p><strong>Phone:</strong> $phone</p>
        <p><strong>Rating:</strong> $rating Stars</p>
        <p><strong>Feedback:</strong><br>$feedback</p>
      </body></html>
    ''';

    await _sendBrevoEmail(
      toName: 'Admin',
      toEmail: AppConstants.contactEmail,
      subject: '[ADMIN] Feedback: $rating Stars from $name',
      htmlContent: adminContent,
    );

    // 2. Auto-Reply to User
    if (email.isNotEmpty) {
      final String userContent =
          '''
        <html><body>
          <h2>Thank You for Your Feedback!</h2>
          <p>Hi $name,</p>
          <p>We appreciate you taking the time to rate us $rating stars.</p>
          <p>Your feedback helps us improve.</p>
          <br>
          <p>Best Regards,<br>${AppConstants.appName} Team</p>
        </body></html>
      ''';

      _sendBrevoEmail(
        toName: name,
        toEmail: email,
        subject: 'Thank you for your feedback - ${AppConstants.appName}',
        htmlContent: userContent,
      ).catchError((e) => print('Auto-reply failed: $e'));
    }
  }

  /// Sends Booking Email (To Admin + Auto-Reply to User)
  static Future<void> sendBookingEmail(Booking booking) async {
    // 1. Send to Admin
    final String adminContent =
        '''
      <html><body>
        <h2>New Cab Booking Request</h2>
        <p><strong>Name:</strong> ${booking.name}</p>
        <p><strong>Mobile:</strong> ${booking.mobile}</p>
        <p><strong>Package:</strong> ${booking.packageSelected}</p>
        <p><strong>From:</strong> ${booking.fromLocation}</p>
        <p><strong>To:</strong> ${booking.toLocation ?? 'N/A'}</p>
        <p><strong>Persons:</strong> ${booking.numberOfPersons}</p>
      </body></html>
    ''';

    await _sendBrevoEmail(
      toName: 'Admin',
      toEmail: AppConstants.contactEmail,
      subject: '[ADMIN] New Booking: ${booking.packageSelected}',
      htmlContent: adminContent,
    );

    // 2. Auto-Reply to User
    if (booking.email.isNotEmpty) {
      final String userContent =
          '''
        <html><body>
          <h2>Booking Request Received</h2>
          <p>Hi ${booking.name},</p>
          <p>We have received your booking request for <strong>${booking.packageSelected}</strong>.</p>
          <p>Our team will contact you shortly to confirm the details.</p>
          <br>
          <p><strong>Pickup:</strong> ${booking.fromLocation}</p>
          <p><strong>Drop:</strong> ${booking.toLocation ?? 'N/A'}</p>
          <br>
          <p>Best Regards,<br>${AppConstants.appName} Team</p>
        </body></html>
      ''';

      _sendBrevoEmail(
        toName: booking.name,
        toEmail: booking.email,
        subject: 'Booking Request Received - ${AppConstants.appName}',
        htmlContent: userContent,
      ).catchError((e) => print('Auto-reply failed: $e'));
    }
  }

  // Backwards compatibility alias
  static Future<void> sendAutoEmail(Booking booking) =>
      sendBookingEmail(booking);

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

  /// Launch email app (Legacy fallback)
  static Future<void> launchEmailApp({
    required String subject,
    required String body,
  }) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: AppConstants.displayEmail,
      queryParameters: {'subject': subject, 'body': body},
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      throw 'Could not launch email app';
    }
  }
}
