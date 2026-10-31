import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class UrlLauncherService {
  Future<void> makePhoneCall(String phoneNumber);
}

class UrlLauncherServiceImpl implements UrlLauncherService {
  @override
  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        debugPrint('Could not launch phone call for $phoneNumber');
      }
    } catch (e) {
      debugPrint('Error launching phone call: $e');
    }
  }
}