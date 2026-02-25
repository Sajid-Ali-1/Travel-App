import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class EmailService {
  static const String recipientEmail = 'Quinn@firstmontanatitle.com';
  static const String testRecipientEmail = 'gultaskeen00@gmail.com';

  /// Sends a property profile request email
  /// Returns true if successful, false otherwise
  static Future<bool> sendEmail({
    required String subject,
    required String formattedBody,
  }) async {
    final email = kDebugMode ? testRecipientEmail : recipientEmail;

    // Create mailto URI. Use percent-encoding (encodeComponent) so spaces
    // become %20 instead of '+' which happens with url-encoded query params.
    final String encodedSubject = Uri.encodeComponent(subject);
    final String encodedBody = Uri.encodeComponent(formattedBody);
    final Uri emailUri = Uri.parse(
      'mailto:$email?subject=$encodedSubject&body=$encodedBody',
    );

    try {
      // Try to launch the email client
      // Use externalApplication mode to open in external email app
      final launched = await launchUrl(
        emailUri,
        mode: LaunchMode.externalApplication,
      );
      return launched;
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('PlatformException sending email: $e');
      }
      // Platform channel error - plugin may not be properly connected
      // This usually requires a full app rebuild (not hot reload)
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Error sending email: $e');
      }
      return false;
    }
  }
}
