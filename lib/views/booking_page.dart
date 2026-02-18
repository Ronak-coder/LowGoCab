import 'package:flutter/material.dart';
import 'package:lowgo_cab/utils/constants.dart';
import 'package:lowgo_cab/models/booking_model.dart';
import 'package:lowgo_cab/services/contact_service.dart';
import 'package:lowgo_cab/services/booking_service.dart';
import 'package:lowgo_cab/widgets/responsive_layout.dart';
import 'package:lowgo_cab/widgets/custom_header.dart';
import 'package:lowgo_cab/widgets/custom_footer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BookingPage extends StatefulWidget {
  final String? selectedPackage;
  const BookingPage({super.key, this.selectedPackage});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  int _persons = 1;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmission(bool isEmail) async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);

      final booking = Booking(
        name: _nameController.text,
        mobile: _mobileController.text,
        email: _emailController.text,
        fromLocation: _fromController.text,
        toLocation: _toController.text,
        numberOfPersons: _persons,
        packageSelected: widget.selectedPackage ?? 'General Inquiry',
      );

      try {
        // Simulate a modern "sending" feel
        await Future.delayed(const Duration(seconds: 1));

        // 1. Save to Backend (Firestore)
        await AppService.saveBooking(booking);

        // 2. Send Notifications
        if (isEmail) {
          // Send email (admin + customer confirmation)
          await ContactService.sendAutoEmail(booking);
          // Also open WhatsApp so admin gets instant notification
          await ContactService.sendWhatsApp(booking);
        } else {
          // WhatsApp only
          await ContactService.sendWhatsApp(booking);
        }

        _showSuccessDialog(isEmail);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      } finally {
        setState(() => _isSubmitting = false);
      }
    }
  }

  void _showSuccessDialog(bool isEmail) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Center(
          child: Icon(
            Icons.check_circle,
            color: AppConstants.successColor,
            size: 60,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Booking Request Sent! 🎉',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            if (isEmail) ...[
              _notifRow(
                Icons.email_rounded,
                Colors.blue,
                'Confirmation email sent to you',
              ),
              const SizedBox(height: 8),
              _notifRow(
                Icons.mark_chat_read_rounded,
                const Color(0xFF25D366),
                'WhatsApp notification sent to admin',
              ),
              const SizedBox(height: 8),
              _notifRow(
                Icons.storage_rounded,
                AppConstants.primaryColor,
                'Booking saved to our system',
              ),
            ] else ...[
              _notifRow(
                Icons.mark_chat_read_rounded,
                const Color(0xFF25D366),
                'WhatsApp message sent to admin',
              ),
              const SizedBox(height: 8),
              _notifRow(
                Icons.storage_rounded,
                AppConstants.primaryColor,
                'Booking saved to our system',
              ),
            ],
            const SizedBox(height: 16),
            const Text(
              'Our team will contact you shortly!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'OK',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _notifRow(IconData icon, Color color, String text) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 13, color: Colors.black87),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);
    return Scaffold(
      backgroundColor: AppConstants.surfaceColor,
      appBar: const CustomHeader(),
      endDrawer: _buildDrawer(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildMinimalHero(isMobile),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : 24,
                vertical: 40,
              ),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: ResponsiveLayout(
                    mobile: Column(
                      children: [
                        _buildFormCard(isMobile),
                        const SizedBox(height: 40),
                        _buildWhyChooseUs(isMobile),
                      ],
                    ),
                    desktop: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 6, child: _buildFormCard(isMobile)),
                        const SizedBox(width: 40),
                        Expanded(flex: 4, child: _buildWhyChooseUs(isMobile)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const CustomFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildMinimalHero(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: isMobile ? 30 : 40),
      decoration: const BoxDecoration(gradient: AppConstants.primaryGradient),
      child: Column(
        children: [
          Text(
            'Book Your Journey',
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 28 : 32,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Fast, Secure & Reliable Cab Service',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: isMobile ? 14 : 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard(bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 24 : 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.selectedPackage != null) _buildSelectedPackageBanner(),
            const Text(
              'Personal Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ResponsiveLayout(
              mobile: Column(
                children: [
                  _buildField(_nameController, 'Your Name', Icons.person),
                  const SizedBox(height: 16),
                  _buildField(_mobileController, 'Mobile Number', Icons.phone),
                ],
              ),
              desktop: Row(
                children: [
                  Expanded(
                    child: _buildField(
                      _nameController,
                      'Your Name',
                      Icons.person,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildField(
                      _mobileController,
                      'Mobile Number',
                      Icons.phone,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildField(_emailController, 'Email Address', Icons.email),
            const SizedBox(height: 32),
            const Text(
              'Route Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildField(_fromController, 'Pickup Location', Icons.my_location),
            const SizedBox(height: 16),
            _buildField(_toController, 'Destination', Icons.location_on),
            const SizedBox(height: 32),
            _buildPersonSelector(),
            const SizedBox(height: 48),
            _isSubmitting
                ? const Center(child: CircularProgressIndicator())
                : isMobile
                ? Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _handleSubmission(false),
                          icon: const FaIcon(
                            FontAwesomeIcons.whatsapp,
                            size: 20,
                          ),
                          label: const Text('BOOK VIA WHATSAPP'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF25D366),
                            padding: const EdgeInsets.symmetric(vertical: 18),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _handleSubmission(true),
                          icon: const Icon(Icons.email_outlined, size: 20),
                          label: const Text('BOOK VIA EMAIL'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppConstants.secondaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                          ),
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _handleSubmission(false),
                          icon: const FaIcon(
                            FontAwesomeIcons.whatsapp,
                            size: 20,
                          ),
                          label: const Text('BOOK VIA WHATSAPP'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF25D366),
                            padding: const EdgeInsets.symmetric(vertical: 20),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _handleSubmission(true),
                          icon: const Icon(Icons.email_outlined, size: 20),
                          label: const Text('BOOK VIA EMAIL'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppConstants.secondaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedPackageBanner() {
    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppConstants.primaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppConstants.primaryColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.local_offer,
            color: AppConstants.primaryColor,
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(
            'Package:',
            style: TextStyle(
              color: AppConstants.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            widget.selectedPackage!,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildField(
    TextEditingController controller,
    String label,
    IconData icon,
  ) {
    return TextFormField(
      controller: controller,
      validator: (v) => v!.isEmpty ? 'Field required' : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppConstants.primaryColor, size: 20),
      ),
    );
  }

  Widget _buildPersonSelector() {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Number of Persons',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: AppConstants.surfaceColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: () =>
                    setState(() => _persons = _persons > 1 ? _persons - 1 : 1),
                icon: const Icon(Icons.remove, size: 18),
              ),
              Text(
                '$_persons',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () => setState(() => _persons++),
                icon: const Icon(Icons.add, size: 18),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWhyChooseUs(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Why Book With Us?',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 24),
        _featureItem(
          Icons.verified_user_rounded,
          'Verified Drivers',
          'All our drivers are background checked and professionally trained.',
        ),
        _featureItem(
          Icons.price_check_rounded,
          'Best Price Guaranteed',
          'Transparent pricing with zero hidden charges for every journey.',
        ),
        _featureItem(
          Icons.support_agent_rounded,
          '24/7 Dedicated Support',
          'We are always available to help you with your booking needs.',
        ),
        _featureItem(
          Icons.directions_car_rounded,
          'Premium Fleet',
          'Travel in comfort with our well-maintained, clean cars.',
        ),
        const SizedBox(height: 40),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppConstants.primaryColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppConstants.primaryColor.withOpacity(0.1),
            ),
          ),
          child: const Column(
            children: [
              Icon(Icons.lock_outline, color: AppConstants.primaryColor),
              SizedBox(height: 12),
              Text(
                'Your data is secure. We use encrypted transmission for all booking requests.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _featureItem(IconData icon, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppConstants.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppConstants.primaryColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(gradient: AppConstants.primaryGradient),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'LOWGO CAB',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text('HOME'),
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const BookingPage()),
            ),
          ),
          ListTile(
            title: const Text('BOOK NOW'),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
