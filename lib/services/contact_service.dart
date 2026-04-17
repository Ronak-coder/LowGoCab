import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:lowgo_cab/utils/constants.dart';
import 'package:lowgo_cab/models/booking_model.dart';

class ContactService {
  // ─────────────────────────────────────────────────────────────────────────
  // CORE SEND METHOD — sends two separate HTTP POST requests (admin + customer)
  // ─────────────────────────────────────────────────────────────────────────
  static Future<void> _sendEmail({
    required String adminSubject,
    required String adminBody,
    String? replyTo,
    String? customerEmail,
    String? customerSubject,
    String? customerBody,
  }) async {
    final String scriptUrl = AppConstants.googleScriptUrl;
    if (scriptUrl.contains('REPLACE')) throw 'URL not configured';

    // ── 1. Admin Notification ──────────────────────────────────────────────
    await _httpPost(scriptUrl, {
      'to': AppConstants.contactEmail,
      'subject': adminSubject,
      'body': adminBody,
      'replyTo': replyTo ?? '',
    });

    // ── 2. Customer Auto-Reply ─────────────────────────────────────────────
    if (customerEmail != null && customerEmail.trim().isNotEmpty) {
      await Future.delayed(const Duration(milliseconds: 300));
      await _httpPost(scriptUrl, {
        'to': customerEmail,
        'subject': customerSubject ?? 'Thank you - LowGo Cab',
        'body': customerBody ?? '<p>Thank you for contacting LowGo Cab!</p>',
        'replyTo': AppConstants.contactEmail,
      });
    }

    await Future.delayed(const Duration(milliseconds: 200));
  }

  /// Fires a cross-platform HTTP POST with JSON payload.
  static Future<void> _httpPost(String url, Map<String, dynamic> payload) async {
    try {
      await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(payload),
      );
    } catch (_) {
      // Fire-and-forget — ignore errors silently
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // PUBLIC API
  // ─────────────────────────────────────────────────────────────────────────

  static Future<void> sendContactEmail({
    required String name,
    required String email,
    required String phone,
    required String message,
  }) async {
    await _sendEmail(
      replyTo: email,
      adminSubject: '[LowGo Cab] New Inquiry from $name',
      adminBody: _adminContactHtml(name, email, phone, message),
      customerEmail: email,
      customerSubject: 'We received your message — LowGo Cab',
      customerBody: _customerContactHtml(name, message),
    );
  }

  static Future<void> sendFeedbackEmail({
    required String name,
    required String email,
    required String phone,
    required int rating,
    required String feedback,
  }) async {
    await _sendEmail(
      replyTo: email,
      adminSubject: '[LowGo Cab] [$rating-Star] Feedback from $name',
      adminBody: _adminFeedbackHtml(name, email, phone, rating, feedback),
      customerEmail: email,
      customerSubject: 'Thank you for your feedback - LowGo Cab',
      customerBody: _customerFeedbackHtml(name, rating, feedback),
    );
  }

  static Future<void> sendBookingEmail(Booking booking) async {
    await _sendEmail(
      replyTo: booking.email,
      adminSubject:
          '[LowGo Cab] New Booking: ${booking.packageSelected ?? "General"} - ${booking.name}',
      adminBody: _adminBookingHtml(booking),
      customerEmail: booking.email,
      customerSubject: 'Booking Confirmed - LowGo Cab',
      customerBody: _customerBookingHtml(booking),
    );
  }

  static Future<void> sendAutoEmail(Booking booking) =>
      sendBookingEmail(booking);

  static Future<void> sendWhatsApp(Booking booking) async {
    final String phone = AppConstants.whatsappNumber
        .replaceAll('+', '')
        .replaceAll(' ', '');
    final Uri uri = Uri.parse(
      'https://wa.me/$phone?text=${Uri.encodeComponent(booking.toWhatsAppMessage())}',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // BEAUTIFUL HTML EMAIL TEMPLATES
  // ─────────────────────────────────────────────────────────────────────────

  static String _emailWrapper({
    required String preheader,
    required String content,
  }) =>
      '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>LowGo Cab</title>
</head>
<body style="margin:0;padding:0;background:#f4f4f8;font-family:Arial,Helvetica,sans-serif;">
  <div style="display:none;max-height:0;overflow:hidden;">$preheader</div>
  <table width="100%" cellpadding="0" cellspacing="0" style="background:#f4f4f8;padding:40px 20px;">
    <tr><td align="center">
      <table width="100%" cellpadding="0" cellspacing="0" style="max-width:620px;">

        <!-- HEADER -->
        <tr><td style="background:linear-gradient(135deg,#EE0B5E 0%,#FF4D8D 100%);border-radius:16px 16px 0 0;padding:40px 40px 32px;text-align:center;">
          <img src="https://lowgocab-2026.web.app/assets/assets/logo.png" alt="LowGo Cab" width="80" height="80" style="border-radius:50%;margin-bottom:16px;display:block;margin-left:auto;margin-right:auto;">
          <h1 style="color:#ffffff;margin:0;font-size:28px;font-weight:900;letter-spacing:-0.5px;">LowGo Cab</h1>
          <p style="color:rgba(255,255,255,0.85);margin:6px 0 0;font-size:14px;letter-spacing:1px;">JAIPUR&apos;S PREMIUM CAB SERVICE</p>
        </td></tr>

        <!-- BODY -->
        <tr><td style="background:#ffffff;padding:40px;">
          $content
        </td></tr>

        <!-- SIGNATURE -->
        <tr><td style="background:#1A1A1A;border-radius:0 0 16px 16px;padding:32px 40px;">
          <table width="100%" cellpadding="0" cellspacing="0">
            <tr>
              <td style="border-right:1px solid #333;padding-right:24px;vertical-align:top;">
                <p style="color:#EE0B5E;font-size:18px;font-weight:900;margin:0 0 4px;">LowGo Cab</p>
                <p style="color:#aaa;font-size:12px;margin:0;">Jaipur&apos;s Trusted Travel Partner</p>
              </td>
              <td style="padding-left:24px;vertical-align:top;">
                <p style="color:#ccc;font-size:12px;margin:0 0 4px;">Tel: ${AppConstants.whatsappNumber}</p>
                <p style="color:#ccc;font-size:12px;margin:0 0 4px;">Email: ${AppConstants.displayEmail}</p>
                <p style="color:#ccc;font-size:12px;margin:0;">Pratap Nagar, Jaipur, Rajasthan</p>
              </td>
            </tr>
          </table>
          <hr style="border:none;border-top:1px solid #333;margin:20px 0;">
          <p style="color:#555;font-size:11px;text-align:center;margin:0;">© 2025 LowGo Cab. All rights reserved. | <a href="${AppConstants.instagramUrl}" style="color:#EE0B5E;text-decoration:none;">Instagram</a></p>
        </td></tr>

      </table>
    </td></tr>
  </table>
</body>
</html>''';

  static String _infoRow(String label, String value) =>
      '<tr><td style="padding:10px 16px;background:#f9f9f9;border-bottom:1px solid #eee;width:35%;color:#666;font-size:13px;font-weight:bold;">$label</td>'
      '<td style="padding:10px 16px;background:#fff;border-bottom:1px solid #eee;color:#1A1A1A;font-size:14px;">$value</td></tr>';

  static String _altRow(String label, String value) =>
      '<tr><td style="padding:10px 16px;background:#fff;border-bottom:1px solid #eee;width:35%;color:#666;font-size:13px;font-weight:bold;">$label</td>'
      '<td style="padding:10px 16px;background:#f9f9f9;border-bottom:1px solid #eee;color:#1A1A1A;font-size:14px;">$value</td></tr>';

  // ── Admin: New Booking ──────────────────────────────────────────────────
  static String _adminBookingHtml(Booking booking) => _emailWrapper(
    preheader:
        'New booking from ${booking.name} — ${booking.packageSelected ?? "General"}',
    content:
        '''
      <div style="display:inline-block;background:#FFF0F5;border:1px solid #EE0B5E;border-radius:8px;padding:6px 16px;margin-bottom:24px;">
        <span style="color:#EE0B5E;font-size:12px;font-weight:bold;letter-spacing:1px;">NEW BOOKING REQUEST</span>
      </div>
      <h2 style="color:#1A1A1A;margin:0 0 8px;font-size:24px;font-weight:900;">A new ride has been booked!</h2>
      <p style="color:#666;font-size:15px;line-height:1.6;margin:0 0 28px;">Please review the booking details below and contact the customer to confirm.</p>
      <table width="100%" cellpadding="0" cellspacing="0" style="border-radius:12px;overflow:hidden;border:1px solid #eee;">
        ${_infoRow('Name', booking.name)}
        ${_altRow('Mobile', booking.mobile)}
        ${_infoRow('Email', booking.email.isEmpty ? 'Not provided' : booking.email)}
        ${_altRow('Package', '<span style="color:#EE0B5E;font-weight:bold;">${booking.packageSelected ?? "General"}</span>')}
        ${_infoRow('From', booking.fromLocation)}
        ${_altRow('To', booking.toLocation)}
        ${_infoRow('Persons', '${booking.numberOfPersons} person${booking.numberOfPersons > 1 ? "s" : ""}')}
        ${booking.travelDate.isNotEmpty ? _altRow('<span style="color:#EE0B5E;">&#128197; Travel Date</span>', '<strong>${booking.travelDate}</strong>') : ''}
        ${booking.pickupTime.isNotEmpty ? _infoRow('<span style="color:#EE0B5E;">&#128336; Pickup Time</span>', '<strong>${booking.pickupTime}</strong>') : ''}
      </table>
      <div style="margin-top:28px;background:#FFF0F5;border-left:4px solid #EE0B5E;border-radius:0 8px 8px 0;padding:16px 20px;">
        <p style="margin:0;color:#EE0B5E;font-weight:bold;font-size:13px;">ACTION REQUIRED</p>
        <p style="margin:6px 0 0;color:#555;font-size:13px;">Call or WhatsApp the customer at <strong>${booking.mobile}</strong> to confirm the booking.</p>
      </div>
    ''',
  );

  // ── Customer: Booking Confirmation ─────────────────────────────────────
  static String _customerBookingHtml(Booking booking) => _emailWrapper(
    preheader:
        'Your LowGo Cab booking is confirmed! We will contact you shortly.',
    content:
        '''
      <div style="text-align:center;margin-bottom:32px;">
        <div style="display:inline-block;background:#E8F5E9;border-radius:50%;width:80px;height:80px;line-height:80px;margin-bottom:16px;">
          <span style="color:#2E7D32;font-size:36px;font-weight:900;">&#10003;</span>
        </div>
        <h2 style="color:#1A1A1A;margin:0 0 8px;font-size:26px;font-weight:900;">Booking Received!</h2>
        <p style="color:#666;font-size:15px;line-height:1.6;margin:0;">Hi <strong>${booking.name}</strong>, we have received your booking request and will contact you on <strong>${booking.mobile}</strong> shortly to confirm.</p>
      </div>
      <div style="background:#f9f9f9;border-radius:12px;padding:24px;margin-bottom:28px;">
        <h3 style="color:#EE0B5E;margin:0 0 16px;font-size:14px;letter-spacing:1px;text-transform:uppercase;">Your Booking Summary</h3>
        <table width="100%" cellpadding="0" cellspacing="0" style="border-radius:8px;overflow:hidden;border:1px solid #eee;">
          ${_infoRow('Package', '<span style="color:#EE0B5E;font-weight:bold;">${booking.packageSelected ?? "General"}</span>')}
          ${_altRow('From', booking.fromLocation)}
          ${_infoRow('To', booking.toLocation)}
          ${_altRow('Persons', '${booking.numberOfPersons} person${booking.numberOfPersons > 1 ? "s" : ""}')}
          ${booking.travelDate.isNotEmpty ? _infoRow('&#128197; Travel Date', '<strong style="color:#EE0B5E;">${booking.travelDate}</strong>') : ''}
          ${booking.pickupTime.isNotEmpty ? _altRow('&#128336; Pickup Time', '<strong style="color:#EE0B5E;">${booking.pickupTime}</strong>') : ''}
        </table>
      </div>
      <div style="background:linear-gradient(135deg,#EE0B5E,#FF4D8D);border-radius:12px;padding:24px;text-align:center;margin-bottom:28px;">
        <p style="color:rgba(255,255,255,0.85);font-size:13px;margin:0 0 8px;letter-spacing:1px;">NEED IMMEDIATE HELP?</p>
        <p style="color:#fff;font-size:22px;font-weight:900;margin:0;">${AppConstants.whatsappNumber}</p>
        <p style="color:rgba(255,255,255,0.75);font-size:12px;margin:6px 0 0;">Available 24/7 on WhatsApp &amp; Call</p>
      </div>
      <p style="color:#999;font-size:12px;text-align:center;line-height:1.6;margin:0;">You are receiving this email because you submitted a booking request on LowGo Cab. If this was not you, please ignore this email.</p>
    ''',
  );

  // ── Admin: Contact Inquiry ──────────────────────────────────────────────
  static String _adminContactHtml(
    String name,
    String email,
    String phone,
    String message,
  ) => _emailWrapper(
    preheader: 'New contact inquiry from $name',
    content:
        '''
      <div style="display:inline-block;background:#E3F2FD;border:1px solid #1976D2;border-radius:8px;padding:6px 16px;margin-bottom:24px;">
        <span style="color:#1976D2;font-size:12px;font-weight:bold;letter-spacing:1px;">NEW CONTACT INQUIRY</span>
      </div>
      <h2 style="color:#1A1A1A;margin:0 0 24px;font-size:22px;font-weight:900;">Someone wants to get in touch!</h2>
      <table width="100%" cellpadding="0" cellspacing="0" style="border-radius:12px;overflow:hidden;border:1px solid #eee;margin-bottom:24px;">
        ${_infoRow('Name', name)}
        ${_altRow('Email', email.isEmpty ? 'Not provided' : email)}
        ${_infoRow('Phone', phone.isEmpty ? 'Not provided' : phone)}
      </table>
      <div style="background:#f9f9f9;border-left:4px solid #1976D2;border-radius:0 8px 8px 0;padding:20px 24px;">
        <p style="color:#666;font-size:12px;font-weight:bold;margin:0 0 8px;letter-spacing:1px;">MESSAGE</p>
        <p style="color:#1A1A1A;font-size:15px;line-height:1.7;margin:0;">$message</p>
      </div>
    ''',
  );

  // ── Customer: Contact Auto-Reply ────────────────────────────────────────
  static String _customerContactHtml(
    String name,
    String message,
  ) => _emailWrapper(
    preheader:
        'We received your message and will get back to you within 24 hours.',
    content:
        '''
      <h2 style="color:#1A1A1A;margin:0 0 8px;font-size:24px;font-weight:900;">Hi $name, we got your message!</h2>
      <p style="color:#666;font-size:15px;line-height:1.7;margin:0 0 24px;">Thank you for reaching out to LowGo Cab. Our team has received your inquiry and will get back to you within <strong>24 hours</strong>.</p>
      <div style="background:#f9f9f9;border-left:4px solid #EE0B5E;border-radius:0 8px 8px 0;padding:20px 24px;margin-bottom:28px;">
        <p style="color:#666;font-size:12px;font-weight:bold;margin:0 0 8px;letter-spacing:1px;">YOUR MESSAGE</p>
        <p style="color:#1A1A1A;font-size:14px;line-height:1.7;margin:0;">$message</p>
      </div>
      <p style="color:#666;font-size:14px;line-height:1.7;margin:0 0 8px;">In the meantime, you can reach us directly:</p>
      <p style="color:#1A1A1A;font-size:14px;margin:0 0 4px;">Tel: <strong>${AppConstants.whatsappNumber}</strong></p>
      <p style="color:#1A1A1A;font-size:14px;margin:0;">Email: <strong>${AppConstants.displayEmail}</strong></p>
    ''',
  );

  // ── Admin: Feedback ─────────────────────────────────────────────────────
  static String _adminFeedbackHtml(
    String name,
    String email,
    String phone,
    int rating,
    String feedback,
  ) {
    final String stars = '*' * rating;
    return _emailWrapper(
      preheader: '[$rating-Star] Feedback from $name',
      content:
          '''
        <div style="display:inline-block;background:#FFF8E1;border:1px solid #FFC107;border-radius:8px;padding:6px 16px;margin-bottom:24px;">
          <span style="color:#F57F17;font-size:12px;font-weight:bold;letter-spacing:1px;">NEW FEEDBACK RECEIVED</span>
        </div>
        <h2 style="color:#1A1A1A;margin:0 0 8px;font-size:22px;font-weight:900;">Customer Feedback</h2>
        <div style="text-align:center;background:#FFF8E1;border-radius:12px;padding:16px;margin:16px 0;">
          <p style="color:#F57F17;font-size:32px;font-weight:900;margin:0;letter-spacing:4px;">$stars</p>
          <p style="color:#F57F17;font-size:14px;margin:4px 0 0;font-weight:bold;">$rating out of 5 stars</p>
        </div>
        <table width="100%" cellpadding="0" cellspacing="0" style="border-radius:12px;overflow:hidden;border:1px solid #eee;margin-bottom:24px;">
          ${_infoRow('Rating', '$rating / 5')}
          ${_altRow('Name', name)}
          ${_infoRow('Email', email.isEmpty ? 'Not provided' : email)}
          ${_altRow('Phone', phone.isEmpty ? 'Not provided' : phone)}
        </table>
        <div style="background:#f9f9f9;border-left:4px solid #FFC107;border-radius:0 8px 8px 0;padding:20px 24px;">
          <p style="color:#666;font-size:12px;font-weight:bold;margin:0 0 8px;letter-spacing:1px;">FEEDBACK</p>
          <p style="color:#1A1A1A;font-size:15px;line-height:1.7;margin:0;">$feedback</p>
        </div>
      ''',
    );
  }

  // ── Customer: Feedback Thank-You ────────────────────────────────────────
  static String _customerFeedbackHtml(
    String name,
    int rating,
    String feedback,
  ) {
    final String stars = '*' * rating;
    return _emailWrapper(
      preheader: 'Thank you for your $rating-star feedback, $name!',
      content:
          '''
        <div style="text-align:center;margin-bottom:28px;">
          <div style="background:#FFF8E1;border-radius:12px;padding:16px;margin-bottom:16px;">
            <p style="color:#F57F17;font-size:32px;font-weight:900;margin:0;letter-spacing:4px;">$stars</p>
          </div>
          <h2 style="color:#1A1A1A;margin:0 0 8px;font-size:24px;font-weight:900;">Thank you, $name!</h2>
          <p style="color:#666;font-size:15px;line-height:1.7;margin:0;">Your <strong>$rating-star feedback</strong> means the world to us. We are constantly working to improve our service and your input helps us do that.</p>
        </div>
        <div style="background:#f9f9f9;border-left:4px solid #FFC107;border-radius:0 8px 8px 0;padding:20px 24px;margin-bottom:28px;">
          <p style="color:#666;font-size:12px;font-weight:bold;margin:0 0 8px;letter-spacing:1px;">YOUR FEEDBACK</p>
          <p style="color:#1A1A1A;font-size:14px;line-height:1.7;margin:0;">$feedback</p>
        </div>
        <p style="color:#666;font-size:14px;text-align:center;line-height:1.7;margin:0;">We look forward to serving you again on your next journey through Jaipur!</p>
      ''',
    );
  }
}
