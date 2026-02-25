class PropertyProfile {
  final String email;
  final String nameOfOwner;
  final String address;
  final String city;
  final String state;
  final String zip;

  PropertyProfile({
    required this.email,
    required this.nameOfOwner,
    required this.address,
    required this.city,
    required this.state,
    required this.zip,
  });

  String get formattedBody =>
      '''
Hello,

I would like to request a property profile for the following property:

PROPERTY INFORMATION:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Owner Name: $nameOfOwner
Address: $address
City: $city
State: $state
Zip Code: $zip

CONTACT INFORMATION:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Email: $email
s
Please provide the property profile at your earliest convenience.

Thank you,
$email
''';
}
