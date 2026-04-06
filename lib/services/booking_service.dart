import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lowgo_cab/models/booking_model.dart';

class AppService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String _bookingsCollection = 'bookings';
  static const String _inquiriesCollection = 'inquiries';
  static const String _feedbackCollection = 'feedback';

  /// Saves booking to Firestore for a proper backend record
  static Future<void> saveBooking(Booking booking) async {
    try {
      await _db.collection(_bookingsCollection).add({
        'name': booking.name,
        'mobile': booking.mobile,
        'email': booking.email,
        'fromLocation': booking.fromLocation,
        'toLocation': booking.toLocation,
        'numberOfPersons': booking.numberOfPersons,
        'packageSelected': booking.packageSelected,
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'Pending', // Initial status for management
      });
      print('Booking saved to Firestore successfully');
    } catch (e) {
      print('Error saving booking to Firestore: $e');
      // Rethrow to handle in UI if needed, but primary is email/whatsapp
      rethrow;
    }
  }

  /// Saves contact inquiry to Firestore
  static Future<void> saveInquiry({
    required String name,
    required String email,
    required String phone,
    required String message,
  }) async {
    try {
      await _db.collection(_inquiriesCollection).add({
        'name': name,
        'email': email,
        'phone': phone,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'New',
      });
      print('Inquiry saved to Firestore successfully');
    } catch (e) {
      print('Error saving inquiry to Firestore: $e');
      rethrow;
    }
  }

  /// Saves feedback to Firestore
  static Future<void> saveFeedback({
    required String name,
    required String email,
    required String phone,
    required int rating,
    required String feedback,
  }) async {
    try {
      await _db.collection(_feedbackCollection).add({
        'name': name,
        'email': email,
        'phone': phone,
        'rating': rating,
        'feedback': feedback,
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'New',
      });
      print('Feedback saved to Firestore successfully');
    } catch (e) {
      print('Error saving feedback to Firestore: $e');
      rethrow;
    }
  }

  /// Optional: Get all bookings
  static Stream<List<Map<String, dynamic>>> getBookings() {
    return _db.collection(_bookingsCollection)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => {
          ...doc.data(),
          'id': doc.id,
        }).toList());
  }
}
