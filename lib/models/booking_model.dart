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
  final String fromLocation;
  final String toLocation;
  final int numberOfPersons;
  final String? packageSelected;

  Booking({
    required this.name,
    required this.mobile,
    required this.fromLocation,
    required this.toLocation,
    required this.numberOfPersons,
    this.packageSelected,
  });

  String toWhatsAppMessage() {
    return 'Hello LowGo Cab,\n\nI want to book a cab.\n'
        'Name: $name\n'
        'Mobile: $mobile\n'
        'From: $fromLocation\n'
        'To: $toLocation\n'
        'Persons: $numberOfPersons\n'
        '${packageSelected != null ? "Package: $packageSelected\n" : ""}'
        '\nPlease contact me.';
  }
}
