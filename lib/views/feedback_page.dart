import 'package:flutter/material.dart';
import 'package:lowgo_cab/utils/constants.dart';
import 'package:lowgo_cab/widgets/custom_header.dart';
import 'package:lowgo_cab/widgets/custom_footer.dart';
import 'package:lowgo_cab/widgets/responsive_layout.dart';
import 'package:lowgo_cab/services/contact_service.dart';
import 'package:lowgo_cab/services/booking_service.dart';
import 'package:lowgo_cab/views/home_page.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage>
    with TickerProviderStateMixin {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _feedbackController = TextEditingController();
  int _rating = 0;
  bool _isSubmitting = false;

  late AnimationController _contentController;

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
    _emailController.dispose();
    _phoneController.dispose();
    _feedbackController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _submitFeedback() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a rating'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_nameController.text.isEmpty || _feedbackController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await AppService.saveFeedback(
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        rating: _rating,
        feedback: _feedbackController.text,
      );

      await ContactService.sendFeedbackEmail(
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        rating: _rating,
        feedback: _feedbackController.text,
      );

      if (mounted) {
        _nameController.clear();
        _emailController.clear();
        _phoneController.clear();
        _feedbackController.clear();
        setState(() => _rating = 0);
        _showSuccessDialog();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sending feedback: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showSuccessDialog() {
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
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Thank You!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              'We appreciate your feedback. It helps us improve our service.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
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
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: _fadeIn(
                    child: _buildFeedbackForm(isMobile),
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
          begin: const Offset(0, 0.1),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    );
  }

  Widget _buildPremiumHero(bool isMobile) {
    return Container(
      width: double.infinity,
      height: isMobile ? 250 : 350,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            'https://images.unsplash.com/photo-1552664730-d307ca884978?w=1600',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black.withOpacity(0.85),
              Colors.black.withOpacity(0.3),
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
                'YOUR FEEDBACK MATTERS',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                  fontSize: isMobile ? 10 : 12,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Help Us Improve',
                style: TextStyle(
                  fontSize: isMobile ? 36 : 56,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: -1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeedbackForm(bool isMobile) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SHARE YOUR EXPERIENCE',
            style: TextStyle(
              color: AppConstants.primaryColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'How was your ride?',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: AppConstants.secondaryColor,
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'SELECT RATING',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 10,
              color: Colors.grey,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 16),
          _buildStarRating(),
          const SizedBox(height: 40),
          _premiumField('Full Name', Icons.person_outline, _nameController),
          const SizedBox(height: 24),
          _premiumField(
            'Email Address',
            Icons.email_outlined,
            _emailController,
          ),
          const SizedBox(height: 24),
          _premiumField(
            'Message & Feedback',
            Icons.message_outlined,
            _feedbackController,
            maxLines: 5,
          ),
          const SizedBox(height: 48),
          SizedBox(
            width: double.infinity,
            height: 64,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _submitFeedback,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.secondaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: _isSubmitting
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'SUBMIT FEEDBACK',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                        fontSize: 15,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStarRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(5, (index) {
        int starValue = index + 1;
        bool active = _rating >= starValue;
        return GestureDetector(
          onTap: () => setState(() => _rating = starValue),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: active
                  ? AppConstants.primaryColor
                  : Colors.grey.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              active ? Icons.star : Icons.star_border,
              color: active ? Colors.white : Colors.grey,
              size: 32,
            ),
          ),
        );
      }),
    );
  }

  Widget _premiumField(
    String label,
    IconData icon,
    TextEditingController controller, {
    int maxLines = 1,
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
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppConstants.primaryColor, size: 20),
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
