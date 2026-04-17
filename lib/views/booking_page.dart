import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lowgo_cab/utils/constants.dart';
import 'package:lowgo_cab/models/booking_model.dart';
import 'package:lowgo_cab/services/contact_service.dart';
import 'package:lowgo_cab/services/booking_service.dart';
import 'package:lowgo_cab/widgets/responsive_layout.dart';
import 'package:lowgo_cab/widgets/custom_header.dart';
import 'package:lowgo_cab/widgets/custom_footer.dart';
import 'package:lowgo_cab/views/home_page.dart';
import 'dart:ui';

class BookingPage extends StatefulWidget {
  final String? selectedPackage;
  const BookingPage({super.key, this.selectedPackage});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _fromController = TextEditingController();
  final _toController = TextEditingController();

  // Date & Time state
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  int _persons = 1;
  bool _isSubmitting = false;

  late AnimationController _contentController;

  // Formatted display strings
  String get _formattedDate =>
      _selectedDate != null
          ? DateFormat('dd MMM yyyy').format(_selectedDate!)
          : '';

  String get _formattedTime =>
      _selectedTime != null ? _selectedTime!.format(context) : '';

  @override
  void initState() {
    super.initState();
    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _contentController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _fromController.dispose();
    _toController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppConstants.primaryColor,
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: Colors.black87,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppConstants.primaryColor,
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: Colors.black87,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedTime = picked);
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
        travelDate: _formattedDate,
        pickupTime: _formattedTime,
      );

      try {
        await AppService.saveBooking(booking);

        try {
          if (isEmail) {
            await ContactService.sendAutoEmail(booking);
          } else {
            ContactService.sendAutoEmail(booking);
            await ContactService.sendWhatsApp(booking);
          }
        } catch (e) {
          debugPrint('Notification error: $e');
        }

        if (mounted) _showSuccessDialog(isEmail);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
          );
        }
      } finally {
        if (mounted) setState(() => _isSubmitting = false);
      }
    }
  }

  void _showSuccessDialog(bool isEmail) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Center(
          child: Icon(
            Icons.check_circle,
            color: AppConstants.successColor,
            size: 64,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Booking Confirmed!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 12),
            Text(
              'Hi ${_nameController.text}, we have received your booking. Our team will contact you shortly.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'GREAT!',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: AppConstants.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _currentStep = 1;

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: const CustomHeader(currentPage: 'booking'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildHeaderSection(isMobile),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : 24,
                vertical: isMobile ? 30 : 50,
              ),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: _fadeIn(
                    child: _buildBookingForm(isMobile),
                    delay: 0.1,
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

  Widget _fadeIn({required Widget child, double delay = 0.0}) {
    final animation = CurvedAnimation(
      parent: _contentController,
      curve: Interval(delay, 1.0, curve: Curves.easeOut),
    );
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.05),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    );
  }

  Widget _buildHeaderSection(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            children: [
              Text(
                'Book Your Cab',
                style: TextStyle(
                  fontSize: isMobile ? 28 : 36,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1A1F36),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Reliable and comfortable transportation at your service',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 30),
              _buildStepIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator() {
    final steps = [
      {'num': '1', 'label': 'Trip Details'},
      {'num': '2', 'label': 'Select Cab'},
      {'num': '3', 'label': 'Passenger Info'},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: steps.asMap().entries.map((entry) {
        final index = entry.key;
        final step = entry.value;
        final isActive = index + 1 == _currentStep;
        final isCompleted = index + 1 < _currentStep;

        return Row(
          children: [
            Column(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: isActive || isCompleted ? AppConstants.primaryGradient : null,
                    color: isActive || isCompleted ? null : Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: isCompleted
                        ? const Icon(Icons.check, color: Colors.white, size: 20)
                        : Text(
                            step['num']!,
                            style: TextStyle(
                              color: isActive ? Colors.white : Colors.grey[600],
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  step['label']!,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                    color: isActive ? AppConstants.primaryColor : Colors.grey[500],
                  ),
                ),
              ],
            ),
            if (index < steps.length - 1)
              Container(
                width: 60,
                height: 2,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                color: isCompleted ? AppConstants.primaryColor : Colors.grey[300],
              ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildBookingForm(bool isMobile) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(
              gradient: AppConstants.primaryGradient,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: const Text(
              'Enter Trip Details',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          // Form
          Padding(
            padding: EdgeInsets.all(isMobile ? 20 : 30),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Pickup & Drop Location
                  Row(
                    children: [
                      Expanded(
                        child: _formField(
                          'Pickup Location',
                          Icons.location_on_outlined,
                          _fromController,
                          'Enter pickup location',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _formField(
                          'Drop Location',
                          Icons.location_on,
                          _toController,
                          'Enter drop location',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Date & Time
                  Row(
                    children: [
                      Expanded(child: _datePickerField()),
                      const SizedBox(width: 16),
                      Expanded(child: _timePickerField()),
                    ],
                  ),
                  const SizedBox(height: 30),
                  // Passenger Count
                  _buildPassengerPicker(),
                  const SizedBox(height: 30),
                  // Search Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: _isSubmitting ? null : () => _handleSubmission(false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.search, size: 20),
                      label: _isSubmitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Search Available Cabs',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _formField(String label, IconData icon, TextEditingController controller, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: AppConstants.primaryColor),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppConstants.primaryColor, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildPassengerPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Number of Passengers',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [1, 2, 3, 4, 5, 6].map((num) {
            final isSelected = _persons == num;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _persons = num),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? AppConstants.primaryColor : Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? AppConstants.primaryColor : Colors.grey[200]!,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '$num',
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  /// Returns a Row on desktop, Column on mobile for two sibling fields.
  Widget _responsiveRow(bool isMobile, Widget left, Widget right) {
    if (isMobile) {
      return Column(
        children: [left, const SizedBox(height: 24), right],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: left),
        const SizedBox(width: 16),
        Expanded(child: right),
      ],
    );
  }

  // ── Date picker tap-field ────────────────────────────────────────────────
  Widget _datePickerField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'TRAVEL DATE',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 10,
            color: Colors.grey,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickDate,
          child: AbsorbPointer(
            child: TextFormField(
              readOnly: true,
              validator: (_) =>
                  _selectedDate == null ? 'Please select travel date' : null,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.calendar_today_outlined,
                  color: AppConstants.primaryColor,
                  size: 20,
                ),
                hintText:
                    _selectedDate != null ? _formattedDate : 'Select date',
                hintStyle: TextStyle(
                  color: _selectedDate != null
                      ? Colors.black87
                      : Colors.grey.withOpacity(0.5),
                  fontWeight: _selectedDate != null
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
                fillColor: Colors.grey.withOpacity(0.04),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
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
          ),
        ),
      ],
    );
  }

  // ── Time picker tap-field ────────────────────────────────────────────────
  Widget _timePickerField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'PICKUP TIME',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 10,
            color: Colors.grey,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickTime,
          child: AbsorbPointer(
            child: TextFormField(
              readOnly: true,
              validator: (_) =>
                  _selectedTime == null ? 'Please select pickup time' : null,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.access_time_outlined,
                  color: AppConstants.primaryColor,
                  size: 20,
                ),
                hintText:
                    _selectedTime != null ? _formattedTime : 'Select time',
                hintStyle: TextStyle(
                  color: _selectedTime != null
                      ? Colors.black87
                      : Colors.grey.withOpacity(0.5),
                  fontWeight: _selectedTime != null
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
                fillColor: Colors.grey.withOpacity(0.04),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
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
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButtons() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Compact mode when card is narrow (mobile)
        final compact = constraints.maxWidth < 420;
        final fontSize = compact ? 11.0 : 13.0;
        final iconSize = compact ? 15.0 : 18.0;
        final vPad = compact ? 16.0 : 20.0;

        return Row(
          children: [
            // ── Email Button ──────────────────────────────────────────
            Expanded(
              child: _buildGradientButton(
                onTap: _isSubmitting ? null : () => _handleSubmission(true),
                gradient: const LinearGradient(
                  colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shadowColor: Colors.black26,
                icon: Icons.email_rounded,
                label: 'SUBMIT VIA EMAIL',
                fontSize: fontSize,
                iconSize: iconSize,
                vPad: vPad,
                compact: compact,
              ),
            ),
            const SizedBox(width: 12),
            // ── WhatsApp Button ───────────────────────────────────────
            Expanded(
              child: _buildGradientButton(
                onTap: _isSubmitting ? null : () => _handleSubmission(false),
                gradient: const LinearGradient(
                  colors: [Color(0xFF25D366), Color(0xFF128C7E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shadowColor: Color(0x5525D366),
                icon: FontAwesomeIcons.whatsapp,
                label: 'BOOK ON WHATSAPP',
                fontSize: fontSize,
                iconSize: iconSize,
                vPad: vPad,
                compact: compact,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildGradientButton({
    required VoidCallback? onTap,
    required LinearGradient gradient,
    required Color shadowColor,
    required IconData icon,
    required String label,
    required double fontSize,
    required double iconSize,
    required double vPad,
    required bool compact,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedOpacity(
        opacity: onTap == null ? 0.5 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: vPad, horizontal: 8),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: iconSize),
              SizedBox(width: compact ? 6 : 8),
              Flexible(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: compact ? 2 : 1,
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: fontSize,
                    letterSpacing: compact ? 0.5 : 0.8,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPersonPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'NUMBER OF PASSENGERS',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 10,
            color: Colors.grey,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: List.generate(6, (index) {
            int val = index + 1;
            bool active = _persons == val;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _persons = val),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: active
                        ? AppConstants.primaryColor
                        : Colors.grey.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: active
                        ? null
                        : Border.all(color: Colors.grey.withOpacity(0.1)),
                  ),
                  child: Center(
                    child: Text(
                      '$val',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: active ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _premiumField(
    String label,
    IconData icon,
    TextEditingController controller,
    String hint, {
    TextInputType keyboardType = TextInputType.text,
    bool required = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 10,
            color: Colors.grey,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: required
              ? (v) => v?.isEmpty == true ? 'Required' : null
              : null,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppConstants.primaryColor, size: 20),
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.grey.withOpacity(0.5),
              fontWeight: FontWeight.normal,
            ),
            fillColor: Colors.grey.withOpacity(0.04),
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
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

  Widget _buildInfoSection(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppConstants.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'WHY BOOK WITH US',
            style: TextStyle(
              color: AppConstants.primaryColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Safe & Premium Journey Experience',
          style: TextStyle(
            fontSize: 42,
            color: AppConstants.secondaryColor,
            fontWeight: FontWeight.w900,
            height: 1.2,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 48),
        _infoItem(
          Icons.verified_user_outlined,
          'Professional Chauffeurs',
          'Our drivers are trained, verified and dedicated to your safety.',
        ),
        const SizedBox(height: 32),
        _infoItem(
          Icons.timer_outlined,
          'Punctual Service',
          'We value your time. Our cabs are always on time, every time.',
        ),
        const SizedBox(height: 32),
        _infoItem(
          Icons.price_check_outlined,
          'Transparent Pricing',
          'No hidden charges. What you see is what you pay.',
        ),
        const SizedBox(height: 48),
        Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            gradient: AppConstants.primaryGradient,
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'HELP LINE',
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                  fontSize: 11,
                ),
              ),
              SizedBox(height: 8),
              Text(
                AppConstants.whatsappNumber,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Available 24/7 for booking support',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _infoItem(IconData icon, String title, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppConstants.primaryColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppConstants.primaryColor, size: 24),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                desc,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
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
              MaterialPageRoute(builder: (context) => const HomePage()),
            ),
          ),
          ListTile(
            title: const Text('CONTACT US'),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
