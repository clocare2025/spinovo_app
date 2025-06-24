 import 'package:url_launcher/url_launcher.dart';

final Uri _url = Uri.parse(
    "https://clocare.in/privacy-policy/"
    // 'https://wa.me/918141116600?text=Hey%20I%20need%20help%20with%20my%20Booking.',
  );

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $_url');
    }
  }
