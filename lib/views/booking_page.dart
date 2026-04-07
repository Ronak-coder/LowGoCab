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

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomHeader(),
      endDrawer: _buildDrawer(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildPremiumHero(isMobile),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : 24,
                vertical: isMobile ? 40 : 80,
              ),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: ResponsiveLayout(
                    mobile: Column(
                      children: [
                        _fadeIn(child: _buildFormCard(isMobile), delay: 0.1),
                        const SizedBox(height: 60),
                        _fadeIn(child: _buildInfoSection(isMobile), delay: 0.3),
                      ],
                    ),
                    desktop: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 6,
                          child: _fadeIn(
                            child: _buildFormCard(isMobile),
                            delay: 0.1,
                          ),
                        ),
                        const SizedBox(width: 80),
                        Expanded(
                          flex: 4,
                          child: _fadeIn(
                            child: _buildInfoSection(isMobile),
                            delay: 0.3,
                          ),
                        ),
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

  Widget _buildPremiumHero(bool isMobile) {
    return Container(
      width: double.infinity,
      height: isMobile ? 300 : 400,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            'https://images.unsplash.com/photo-1449156001931-82832044e131?w=1600',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black.withOpacity(0.9),
              Colors.black.withOpacity(0.4),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'RESERVE YOUR TAXI',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                  fontSize: isMobile ? 10 : 12,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Instant Booking',
                style: TextStyle(
                  fontSize: isMobile ? 44 : 64,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: -1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormCard(bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 24 : 48),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 60,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'TRIP DETAILS',
              style: TextStyle(
                color: AppConstants.primaryColor,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Enter Booking Info',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 32),

            // Passenger Name
            _premiumField(
              'Passenger Name',
              Icons.person_outline,
              _nameController,
              'Enter your full name',
            ),
            const SizedBox(height: 24),

            // Mobile + Email
            _responsiveRow(
              isMobile,
              _premiumField(
                'Mobile Number',
                Icons.phone_android_outlined,
                _mobileController,
                '98765 43210',
                keyboardType: TextInputType.phone,
              ),
              _premiumField(
                'Email (Optional)',
                Icons.email_outlined,
                _emailController,
                'you@example.com',
                keyboardType: TextInputType.emailAddress,
                required: false,
              ),
            ),
            const SizedBox(height: 24),

            // Pickup + Drop Location
            _responsiveRow(
              isMobile,
              _premiumField(
                'Pickup Location',
                Icons.location_on_outlined,
                _fromController,
                'Pratap Nagar, Jaipur',
              ),
              _premiumField(
                'Drop Location',
                Icons.flag_outlined,
                _toController,
                'Airport / Railway Station',
              ),
            ),
            const SizedBox(height: 24),

            // Travel Date + Pickup Time
            _responsiveRow(
              isMobile,
              _datePickerField(),
              _timePickerField(),
            ),
            const SizedBox(height: 24),

            // Persons picker
            _buildPersonPicker(),
            const SizedBox(height: 48),

            // Submit buttons — always side-by-side, adaptive sizing
            _buildSubmitButtons(),
          ],
        ),
      ),
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
        const Text(
          'WHY BOOK WITH US',
          style: TextStyle(
            color: AppConstants.primaryColor,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Safe & Premium Journey Experience',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            height: 1.2,
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
