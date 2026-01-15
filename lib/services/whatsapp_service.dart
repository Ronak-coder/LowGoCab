import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class WhatsAppService {
  static Future<void> launchWhatsApp({
    required String phone,
    required String message,
  }) async {
    final String url;

    if (kIsWeb) {
      url = "https://wa.me/$phone/?text=${Uri.encodeComponent(message)}";
    } else {
      if (Platform.isAndroid) {
        url =
            "whatsapp://send?phone=$phone&text=${Uri.encodeComponent(message)}";
      } else {
        url = "https://wa.me/$phone/?text=${Uri.encodeComponent(message)}";
      }
    }

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      // Fallback to web link if app not installed
      final String webUrl =
          "https://wa.me/$phone/?text=${Uri.encodeComponent(message)}";
      await launchUrl(Uri.parse(webUrl), mode: LaunchMode.externalApplication);
    }
  }
}
