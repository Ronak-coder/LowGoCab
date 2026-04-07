class Package {
  final String title;
  final String price;
  final String description;
  final String imageUrl;

  Package({
    required this.title,
    required this.price,
    required this.description,
    required this.imageUrl,
  });
}

class Booking {
  final String name;
  final String mobile;
  final String email;
  final String fromLocation;
  final String toLocation;
  final int numberOfPersons;
  final String? packageSelected;
  final String travelDate; // e.g. "07 Apr 2026"
  final String pickupTime; // e.g. "10:30 AM"

  Booking({
    required this.name,
    required this.mobile,
    this.email = '',
    required this.fromLocation,
    required this.toLocation,
    required this.numberOfPersons,
    this.packageSelected,
    this.travelDate = '',
    this.pickupTime = '',
  });

  String toWhatsAppMessage() {
    return 'Hello LowGo Cab,\n\nI want to book a cab.\n'
        'Name: $name\n'
        'Mobile: $mobile\n'
        '${email.isNotEmpty ? "Email: $email\n" : ""}'
        'From: $fromLocation\n'
        'To: $toLocation\n'
        'Persons: $numberOfPersons\n'
        '${travelDate.isNotEmpty ? "Travel Date: $travelDate\n" : ""}'
        '${pickupTime.isNotEmpty ? "Pickup Time: $pickupTime\n" : ""}'
        '${packageSelected != null ? "Package: $packageSelected\n" : ""}'
        '\nPlease contact me.';
  }
}
