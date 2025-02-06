import 'package:url_launcher/url_launcher.dart';

class UrlManager {
  const UrlManager._();

  static Future<void> launch(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw 'Could not launch $url';
      }
    } catch (_) {
      rethrow;
    }
  }
}
