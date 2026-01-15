import 'package:flutter/material.dart';
import 'package:lowgo_cab/models/booking_model.dart';
import 'package:lowgo_cab/services/whatsapp_service.dart';
import 'package:lowgo_cab/utils/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lowgo_cab/widgets/custom_header.dart';
import 'package:lowgo_cab/widgets/responsive_layout.dart';

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
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  int _numberOfPersons = 1;

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  void _submitBooking() {
    if (_formKey.currentState!.validate()) {
      final booking = Booking(
        name: _nameController.text,
        mobile: _mobileController.text,
        fromLocation: _fromController.text,
        toLocation: _toController.text,
        numberOfPersons: _numberOfPersons,
        packageSelected: widget.selectedPackage,
      );

      WhatsAppService.launchWhatsApp(
        phone: AppConstants.whatsappNumber,
        message: booking.toWhatsAppMessage(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: const CustomHeader(),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 900),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderSection(),
                const SizedBox(height: 48),
                _buildFormSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppConstants.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.calendar_month,
                color: AppConstants.primaryColor,
              ),
            ),
            const SizedBox(width: 16),
            const Text(
              'Secure Your Ride',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppConstants.primaryColor,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Booking Details',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w900,
            color: AppConstants.secondaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Fill in the details below. We will contact you on WhatsApp to confirm.',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildFormSection() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.selectedPackage != null) ...[
              _buildSelectedPackageBanner(),
              const SizedBox(height: 32),
            ],

            const Text(
              'Personal Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ResponsiveLayout(
              mobile: Column(
                children: [
                  _buildInputField(
                    controller: _nameController,
                    label: 'Full Name',
                    hint: 'e.g. Rahul Sharma',
                    icon: Icons.person_outline,
                    validator: (v) => v!.isEmpty ? 'Name required' : null,
                  ),
                  const SizedBox(height: 20),
                  _buildInputField(
                    controller: _mobileController,
                    label: 'Mobile Number',
                    hint: '10 digit mobile number',
                    icon: Icons.phone_android_outlined,
                    keyboardType: TextInputType.phone,
                    validator: (v) => v!.length < 10 ? 'Invalid mobile' : null,
                  ),
                ],
              ),
              desktop: Row(
                children: [
                  Expanded(
                    child: _buildInputField(
                      controller: _nameController,
                      label: 'Full Name',
                      hint: 'e.g. Rahul Sharma',
                      icon: Icons.person_outline,
                      validator: (v) => v!.isEmpty ? 'Name required' : null,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: _buildInputField(
                      controller: _mobileController,
                      label: 'Mobile Number',
                      hint: '10 digit mobile number',
                      icon: Icons.phone_android_outlined,
                      keyboardType: TextInputType.phone,
                      validator: (v) =>
                          v!.length < 10 ? 'Invalid mobile' : null,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
            const Text(
              'Route Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            _buildInputField(
              controller: _fromController,
              label: 'Pickup Location',
              hint: 'Search pickup location...',
              icon: Icons.my_location,
              suffixIcon: Icons.map,
              validator: (v) => v!.isEmpty ? 'Pickup location required' : null,
            ),
            const SizedBox(height: 20),
            _buildInputField(
              controller: _toController,
              label: 'Drop Location',
              hint: 'Search destination...',
              icon: Icons.location_on_outlined,
              suffixIcon: Icons.explore,
              validator: (v) => v!.isEmpty ? 'Drop location required' : null,
            ),

            const SizedBox(height: 40),
            _buildPersonsSelector(),

            const SizedBox(height: 60),
            SizedBox(
              width: double.infinity,
              height: 64,
              child: ElevatedButton.icon(
                onPressed: _submitBooking,
                icon: const FaIcon(FontAwesomeIcons.whatsapp, size: 24),
                label: const Text(
                  'Book Now on WhatsApp',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF25D366), // WhatsApp Green
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedPackageBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppConstants.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppConstants.primaryColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: AppConstants.primaryColor,
            radius: 12,
            child: Icon(Icons.check, size: 16, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Text(
            'Selected Package:',
            style: TextStyle(
              color: Colors.grey[700],
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            widget.selectedPackage!,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppConstants.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    IconData? suffixIcon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppConstants.secondaryColor,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: Colors.grey),
            suffixIcon: suffixIcon != null
                ? Icon(suffixIcon, size: 20, color: AppConstants.primaryColor)
                : null,
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: AppConstants.primaryColor,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPersonsSelector() {
    return Row(
      children: [
        const Text(
          'Passengers',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            children: [
              _buildCounterBtn(Icons.remove, () {
                if (_numberOfPersons > 1) setState(() => _numberOfPersons--);
              }),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  '$_numberOfPersons',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _buildCounterBtn(
                Icons.add,
                () => setState(() => _numberOfPersons++),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCounterBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4),
          ],
        ),
        child: Icon(icon, size: 20, color: AppConstants.primaryColor),
      ),
    );
  }
}

extension ResponsiveFormField on Widget {
  Widget responsive(BuildContext context) {
    if (ResponsiveLayout.isMobile(context)) {
      return Column(
        children: [this],
      ); // This logic is simplified, usually we wrap Row children
    }
    return this;
  }
}
