import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;
import 'package:url_launcher/url_launcher.dart';
import 'package:lowgo_cab/utils/constants.dart';
import 'package:lowgo_cab/models/booking_model.dart';

/// ContactService — sends emails via Google Apps Script (free relay).
/// Uses dart:js fetch with mode:'no-cors' to bypass browser CORS restriction.
/// Sends both admin notification AND customer confirmation emails.
class ContactService {
  /// Core method: fires a no-cors fetch to Google Apps Script.
  /// Supports sending to both admin and customer in one call.
  static Future<void> _sendEmail({
    required String adminSubject,
    required String adminBody,
    String? replyTo,
    String? customerEmail,
    String? customerSubject,
    String? customerBody,
  }) async {
    final String scriptUrl = AppConstants.googleScriptUrl;

    if (scriptUrl.contains('REPLACE')) {
      throw 'Google Apps Script URL not configured.\nSee lib/utils/secrets.dart for setup instructions.';
    }

    final Map<String, dynamic> payload = {
      'to': AppConstants.contactEmail,
      'subject': adminSubject,
      'body': adminBody,
      'replyTo': replyTo ?? '',
      'customerEmail': customerEmail ?? '',
      'customerSubject': customerSubject ?? '',
      'customerBody': customerBody ?? '',
    };

    final String bodyJson = json.encode(json.encode(payload));

    // Use JS fetch with mode:'no-cors' — bypasses CORS, request reaches Google.
    // Response is opaque (unreadable) but email IS sent successfully.
    js.context.callMethod('eval', [
      '''
      fetch("$scriptUrl", {
        method: "POST",
        mode: "no-cors",
        headers: { "Content-Type": "application/json" },
        body: $bodyJson
      }).then(function() {
        console.log("[LowGo Cab] Email dispatched to Google Apps Script");
      }).catch(function(err) {
        console.error("[LowGo Cab] Email fetch error:", err);
      });
      ''',
    ]);

    await Future.delayed(const Duration(milliseconds: 500));
    print('Email dispatched via Google Apps Script (no-cors mode)');
  }

  /// Sends Contact Form Email — Admin notification + Customer auto-reply
  static Future<void> sendContactEmail({
    required String name,
    required String email,
    required String phone,
    required String message,
  }) async {
    await _sendEmail(
      replyTo: email.isNotEmpty ? email : null,
      adminSubject: '[LowGo Cab] New Inquiry from $name',
      adminBody:
          '''
        <div style="font-family:Arial,sans-serif;max-width:600px;margin:auto;padding:24px;border:1px solid #eee;border-radius:12px;">
          <h2 style="color:#EE0B5E;">📩 New Contact Inquiry</h2>
          <table style="width:100%;border-collapse:collapse;">
            <tr><td style="padding:8px;color:#666;width:120px;"><b>Name</b></td><td style="padding:8px;">$name</td></tr>
            <tr style="background:#f9f9f9;"><td style="padding:8px;color:#666;"><b>Email</b></td><td style="padding:8px;">${email.isEmpty ? 'Not provided' : email}</td></tr>
            <tr><td style="padding:8px;color:#666;"><b>Phone</b></td><td style="padding:8px;">${phone.isEmpty ? 'Not provided' : phone}</td></tr>
          </table>
          <div style="margin-top:16px;padding:16px;background:#f9f9f9;border-radius:8px;">
            <b style="color:#666;">Message:</b><p style="margin-top:8px;">$message</p>
          </div>
          <p style="margin-top:24px;color:#aaa;font-size:12px;">Sent via LowGo Cab website.</p>
        </div>
      ''',
      // Customer confirmation
      customerEmail: email.isNotEmpty ? email : null,
      customerSubject: 'We received your message — LowGo Cab',
      customerBody:
          '''
        <div style="font-family:Arial,sans-serif;max-width:600px;margin:auto;padding:24px;border:1px solid #eee;border-radius:12px;">
          <div style="background:linear-gradient(135deg,#EE0B5E,#FF4D8D);padding:32px;border-radius:12px;text-align:center;margin-bottom:24px;">
            <h1 style="color:white;margin:0;font-size:28px;">LowGo Cab 🚖</h1>
            <p style="color:rgba(255,255,255,0.85);margin:8px 0 0;">Jaipur's Trusted Cab Service</p>
          </div>
          <h2 style="color:#1A1A1A;">Hi $name, we got your message! ✅</h2>
          <p style="color:#555;line-height:1.7;">Thank you for reaching out to us. Our team has received your inquiry and will get back to you within <b>24 hours</b>.</p>
          <div style="background:#f9f9f9;padding:16px;border-radius:8px;margin:20px 0;border-left:4px solid #EE0B5E;">
            <b style="color:#666;">Your Message:</b>
            <p style="margin-top:8px;color:#333;">$message</p>
          </div>
          <p style="color:#555;">In the meantime, you can reach us directly:</p>
          <p style="color:#555;">📞 <b>${AppConstants.whatsappNumber}</b><br>📧 <b>${AppConstants.displayEmail}</b></p>
          <hr style="border:none;border-top:1px solid #eee;margin:24px 0;">
          <p style="color:#aaa;font-size:12px;text-align:center;">© LowGo Cab — Jaipur, Rajasthan, India</p>
        </div>
      ''',
    );
  }

  /// Sends Feedback Email — Admin notification + Customer thank-you
  static Future<void> sendFeedbackEmail({
    required String name,
    required String email,
    required String phone,
    required int rating,
    required String feedback,
  }) async {
    final String stars = '⭐' * rating;
    await _sendEmail(
      replyTo: email.isNotEmpty ? email : null,
      adminSubject: '[LowGo Cab] $stars Feedback from $name',
      adminBody:
          '''
        <div style="font-family:Arial,sans-serif;max-width:600px;margin:auto;padding:24px;border:1px solid #eee;border-radius:12px;">
          <h2 style="color:#EE0B5E;">⭐ New Feedback Received</h2>
          <div style="font-size:32px;text-align:center;margin:16px 0;">$stars</div>
          <table style="width:100%;border-collapse:collapse;">
            <tr><td style="padding:8px;color:#666;width:120px;"><b>Rating</b></td><td style="padding:8px;">$rating / 5</td></tr>
            <tr style="background:#f9f9f9;"><td style="padding:8px;color:#666;"><b>Name</b></td><td style="padding:8px;">$name</td></tr>
            <tr><td style="padding:8px;color:#666;"><b>Email</b></td><td style="padding:8px;">${email.isEmpty ? 'Not provided' : email}</td></tr>
            <tr style="background:#f9f9f9;"><td style="padding:8px;color:#666;"><b>Phone</b></td><td style="padding:8px;">${phone.isEmpty ? 'Not provided' : phone}</td></tr>
          </table>
          <div style="margin-top:16px;padding:16px;background:#f9f9f9;border-radius:8px;">
            <b style="color:#666;">Feedback:</b><p style="margin-top:8px;">$feedback</p>
          </div>
        </div>
      ''',
      // Customer thank-you (only if email provided)
      customerEmail: email.isNotEmpty ? email : null,
      customerSubject: 'Thank you for your feedback — LowGo Cab',
      customerBody:
          '''
        <div style="font-family:Arial,sans-serif;max-width:600px;margin:auto;padding:24px;border:1px solid #eee;border-radius:12px;">
          <div style="background:linear-gradient(135deg,#EE0B5E,#FF4D8D);padding:32px;border-radius:12px;text-align:center;margin-bottom:24px;">
            <h1 style="color:white;margin:0;font-size:28px;">LowGo Cab 🚖</h1>
            <p style="color:rgba(255,255,255,0.85);margin:8px 0 0;">Jaipur's Trusted Cab Service</p>
          </div>
          <h2 style="color:#1A1A1A;">Thank you, $name! $stars</h2>
          <p style="color:#555;line-height:1.7;">We truly appreciate you taking the time to share your experience with us. Your <b>$rating-star feedback</b> means a lot to our team and helps us serve you better.</p>
          <div style="background:#f9f9f9;padding:16px;border-radius:8px;margin:20px 0;border-left:4px solid #EE0B5E;">
            <b style="color:#666;">Your Feedback:</b>
            <p style="margin-top:8px;color:#333;">$feedback</p>
          </div>
          <p style="color:#555;">We look forward to serving you again on your next journey! 🙏</p>
          <hr style="border:none;border-top:1px solid #eee;margin:24px 0;">
          <p style="color:#aaa;font-size:12px;text-align:center;">© LowGo Cab — Jaipur, Rajasthan, India</p>
        </div>
      ''',
    );
  }

  /// Sends Booking Email — Admin notification + Customer booking confirmation
  static Future<void> sendBookingEmail(Booking booking) async {
    await _sendEmail(
      replyTo: booking.email.isNotEmpty ? booking.email : null,
      adminSubject:
          '[LowGo Cab] 🚖 New Booking: ${booking.packageSelected} by ${booking.name}',
      adminBody:
          '''
        <div style="font-family:Arial,sans-serif;max-width:600px;margin:auto;padding:24px;border:1px solid #eee;border-radius:12px;">
          <h2 style="color:#EE0B5E;">🚖 New Cab Booking Request</h2>
          <table style="width:100%;border-collapse:collapse;">
            <tr><td style="padding:8px;color:#666;width:120px;"><b>Name</b></td><td style="padding:8px;">${booking.name}</td></tr>
            <tr style="background:#f9f9f9;"><td style="padding:8px;color:#666;"><b>Mobile</b></td><td style="padding:8px;">${booking.mobile}</td></tr>
            <tr><td style="padding:8px;color:#666;"><b>Email</b></td><td style="padding:8px;">${booking.email.isEmpty ? 'Not provided' : booking.email}</td></tr>
            <tr style="background:#f9f9f9;"><td style="padding:8px;color:#666;"><b>Package</b></td><td style="padding:8px;font-weight:bold;color:#EE0B5E;">${booking.packageSelected}</td></tr>
            <tr><td style="padding:8px;color:#666;"><b>From</b></td><td style="padding:8px;">${booking.fromLocation}</td></tr>
            <tr style="background:#f9f9f9;"><td style="padding:8px;color:#666;"><b>To</b></td><td style="padding:8px;">${booking.toLocation ?? 'N/A'}</td></tr>
            <tr><td style="padding:8px;color:#666;"><b>Persons</b></td><td style="padding:8px;">${booking.numberOfPersons}</td></tr>
          </table>
        </div>
      ''',
      // Customer booking confirmation
      customerEmail: booking.email.isNotEmpty ? booking.email : null,
      customerSubject: 'Booking Confirmed — LowGo Cab 🚖',
      customerBody:
          '''
        <div style="font-family:Arial,sans-serif;max-width:600px;margin:auto;padding:24px;border:1px solid #eee;border-radius:12px;">
          <div style="background:linear-gradient(135deg,#EE0B5E,#FF4D8D);padding:32px;border-radius:12px;text-align:center;margin-bottom:24px;">
            <h1 style="color:white;margin:0;font-size:28px;">LowGo Cab 🚖</h1>
            <p style="color:rgba(255,255,255,0.85);margin:8px 0 0;">Jaipur's Trusted Cab Service</p>
          </div>
          <h2 style="color:#1A1A1A;">Booking Request Received! ✅</h2>
          <p style="color:#555;line-height:1.7;">Hi <b>${booking.name}</b>, your booking request has been received. Our team will contact you shortly on <b>${booking.mobile}</b> to confirm the details.</p>
          <div style="background:#f9f9f9;border-radius:12px;padding:20px;margin:20px 0;">
            <h3 style="color:#EE0B5E;margin-top:0;">📋 Booking Summary</h3>
            <table style="width:100%;border-collapse:collapse;">
              <tr><td style="padding:6px;color:#666;width:100px;"><b>Package</b></td><td style="padding:6px;font-weight:bold;color:#EE0B5E;">${booking.packageSelected}</td></tr>
              <tr style="background:white;"><td style="padding:6px;color:#666;"><b>From</b></td><td style="padding:6px;">${booking.fromLocation}</td></tr>
              <tr><td style="padding:6px;color:#666;"><b>To</b></td><td style="padding:6px;">${booking.toLocation ?? 'N/A'}</td></tr>
              <tr style="background:white;"><td style="padding:6px;color:#666;"><b>Persons</b></td><td style="padding:6px;">${booking.numberOfPersons}</td></tr>
            </table>
          </div>
          <p style="color:#555;">Need help? Contact us directly:</p>
          <p style="color:#555;">📞 <b>${AppConstants.whatsappNumber}</b><br>📧 <b>${AppConstants.displayEmail}</b></p>
          <hr style="border:none;border-top:1px solid #eee;margin:24px 0;">
          <p style="color:#aaa;font-size:12px;text-align:center;">© LowGo Cab — Jaipur, Rajasthan, India</p>
        </div>
      ''',
    );
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
