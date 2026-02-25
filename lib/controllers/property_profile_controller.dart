import 'package:get/get.dart';
import '../models/property_profile.dart';
import '../services/email_service.dart';

enum EmailSendResult { success, failure }

class PropertyProfileController extends GetxController {
  /// Sends a property profile request email
  /// Returns EmailSendResult indicating success or failure
  Future<EmailSendResult> sendPropertyProfileEmail({
    required String email,
    required String nameOfOwner,
    required String address,
    required String city,
    required String state,
    required String zip,
  }) async {
    final propertyProfile = PropertyProfile(
      email: email,
      nameOfOwner: nameOfOwner,
      address: address,
      city: city,
      state: state,
      zip: zip,
    );

    final success = await EmailService.sendEmail(
      subject: 'Property Profile Request',
      formattedBody: propertyProfile.formattedBody,
    );

    return success ? EmailSendResult.success : EmailSendResult.failure;
  }
}
