import 'package:flutter/material.dart';
import 'package:lowgo_cab/utils/constants.dart';
import 'package:lowgo_cab/views/packages_page.dart';
import 'package:lowgo_cab/views/contact_page.dart';
import 'package:lowgo_cab/widgets/responsive_layout.dart';
import 'package:lowgo_cab/widgets/custom_header.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lowgo_cab/widgets/custom_footer.dart';
import 'dart:ui';
import 'booking_page.dart';
import 'package:lowgo_cab/views/feedback_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: const CustomHeader(currentPage: 'home'),
      endDrawer: _buildDrawer(context),
      floatingActionButton: _buildFloatingWhatsApp(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _fadeIn(child: _buildHeroSection(context), delay: 0),
            _fadeIn(child: _buildQuickBookingCard(context), delay: 200),
            _fadeIn(child: _buildWhyChooseSection(context), delay: 400),
            _fadeIn(child: _buildFeaturedPackages(context), delay: 600),
            _fadeIn(child: _buildStatsSection(context), delay: 800),
            const CustomFooter(),
          ],
        ),
      ),
    );
  }

  Widget _fadeIn({required Widget child, int delay = 0}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 1000 + delay),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  Widget _buildFloatingWhatsApp() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16, right: 16),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => launchUrl(
            Uri.parse(
              'https://wa.me/${AppConstants.whatsappNumber.replaceAll('+', '').replaceAll(' ', '')}',
            ),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: AppConstants.primaryGradient,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: AppConstants.primaryColor.withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    FontAwesomeIcons.whatsapp,
                    color: AppConstants.primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Book on WhatsApp',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);
    return Container(
      width: double.infinity,
      height: isMobile ? 500 : 600,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF0D8BFF),
            Color(0xFF00A8E8),
            Color(0xFF00C853),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 900),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _fadeIn(
                delay: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.star,
                      color: AppConstants.accentColor,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Discover Your Next Adventure',
                      style: TextStyle(
                        color: AppConstants.accentColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _fadeIn(
                delay: 200,
                child: Text(
                  'Explore the World with Us',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isMobile ? 36 : 56,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.1,
                    letterSpacing: -1,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _fadeIn(
                delay: 300,
                child: Text(
                  'Create unforgettable memories with our curated travel packages and reliable cab services',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isMobile ? 16 : 18,
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              _fadeIn(
                delay: 400,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _GradientButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PackagesPage(),
                        ),
                      ),
                      text: 'Explore Packages',
                      icon: Icons.arrow_forward,
                    ),
                    if (!isMobile) ...[
                      const SizedBox(width: 16),
                      _OutlinedWhiteButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BookingPage(),
                          ),
                        ),
                        text: 'Book a Cab',
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickBookingCard(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);
    return Transform.translate(
      offset: const Offset(0, -60),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1100),
          margin: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 40,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  gradient: AppConstants.primaryGradient,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.white, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      'Quick Cab Booking',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isMobile ? 16 : 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              // Form Fields
              Padding(
                padding: EdgeInsets.all(isMobile ? 20 : 30),
                child: isMobile
                    ? Column(
                        children: [
                          _bookingField(Icons.location_on_outlined, 'Pickup Location', 'Enter pickup location'),
                          const SizedBox(height: 16),
                          _bookingField(Icons.location_on, 'Drop Location', 'Enter drop location'),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _bookingField(Icons.calendar_today, 'Date', 'dd/mm/yyyy'),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _bookingField(Icons.access_time, 'Time', '--:--'),
                              ),
                            ],
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: _bookingField(Icons.location_on_outlined, 'Pickup Location', 'Enter pickup location'),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _bookingField(Icons.location_on, 'Drop Location', 'Enter drop location'),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _bookingField(Icons.calendar_today, 'Date', 'dd/mm/yyyy'),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _bookingField(Icons.access_time, 'Time', '--:--'),
                          ),
                        ],
                      ),
              ),
              // Search Button
              Padding(
                padding: EdgeInsets.fromLTRB(
                  isMobile ? 20 : 30,
                  0,
                  isMobile ? 20 : 30,
                  isMobile ? 20 : 30,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const BookingPage()),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.search, size: 20),
                    label: const Text(
                      'Search Available Cabs',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bookingField(IconData icon, String label, String hint) {
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
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Text(
            hint,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWhyChooseSection(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Text(
                'Why Choose TravelExplore?',
                style: TextStyle(
                  fontSize: isMobile ? 28 : 36,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1A1F36),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Your satisfaction is our priority',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 50),
              ResponsiveLayout(
                mobile: Column(
                  children: [
                    _whyChooseCard(
                      Icons.price_check,
                      Colors.blue[100]!,
                      Colors.blue,
                      'Best Price Guarantee',
                      'We offer competitive prices and best value packages for all your travel needs.',
                    ),
                    const SizedBox(height: 20),
                    _whyChooseCard(
                      Icons.verified_user,
                      Colors.green[100]!,
                      Colors.green,
                      'Safe & Secure',
                      'Your safety is our priority. All bookings are secure and verified.',
                    ),
                    const SizedBox(height: 20),
                    _whyChooseCard(
                      Icons.support_agent,
                      Colors.purple[100]!,
                      Colors.purple,
                      '24/7 Support',
                      'Our dedicated support team is available round the clock to assist you.',
                    ),
                  ],
                ),
                tablet: Row(
                  children: [
                    Expanded(
                      child: _whyChooseCard(
                        Icons.price_check,
                        Colors.blue[100]!,
                        Colors.blue,
                        'Best Price Guarantee',
                        'We offer competitive prices and best value packages for all your travel needs.',
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _whyChooseCard(
                        Icons.verified_user,
                        Colors.green[100]!,
                        Colors.green,
                        'Safe & Secure',
                        'Your safety is our priority. All bookings are secure and verified.',
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _whyChooseCard(
                        Icons.support_agent,
                        Colors.purple[100]!,
                        Colors.purple,
                        '24/7 Support',
                        'Our dedicated support team is available round the clock to assist you.',
                      ),
                    ),
                  ],
                ),
                desktop: Row(
                  children: [
                    Expanded(
                      child: _whyChooseCard(
                        Icons.price_check,
                        Colors.blue[100]!,
                        Colors.blue,
                        'Best Price Guarantee',
                        'We offer competitive prices and best value packages for all your travel needs.',
                      ),
                    ),
                    const SizedBox(width: 30),
                    Expanded(
                      child: _whyChooseCard(
                        Icons.verified_user,
                        Colors.green[100]!,
                        Colors.green,
                        'Safe & Secure',
                        'Your safety is our priority. All bookings are secure and verified.',
                      ),
                    ),
                    const SizedBox(width: 30),
                    Expanded(
                      child: _whyChooseCard(
                        Icons.support_agent,
                        Colors.purple[100]!,
                        Colors.purple,
                        '24/7 Support',
                        'Our dedicated support team is available round the clock to assist you.',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _whyChooseCard(IconData icon, Color bgColor, Color iconColor, String title, String desc) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1F36),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            desc,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedPackages(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);
    final packages = [
      {
        'title': 'One Day Jaipur Sightseeing Tour',
        'location': 'Jaipur City',
        'duration': '12 Hours',
        'price': '\₹1,500',
        'rating': '4.9',
        'image': 'https://images.unsplash.com/photo-1477587458883-47145ed94245?w=600',
        'highlights': ['Amer Fort tour', 'Hawa Mahal visit', 'Jal Mahal view', 'City Palace'],
      },
      {
        'title': 'Jaipur to Khatu Shyam Ji',
        'location': 'Jaipur City',
        'duration': '8 Hours',
        'price': '\₹2,199',
        'rating': '4.8',
        'image': 'https://images.unsplash.com/photo-1561361058-c24cecae35ca?w=600',
        'highlights': ['Temple darshan', 'AC cab included', 'Toll & parking', 'Pickup & drop'],
      },
      {
        'title': 'Same Day Agra Tour From Jaipur',
        'location': 'Agra',
        'duration': 'Full Day',
        'price': '\₹5,500',
        'rating': '4.7',
        'image': 'https://images.unsplash.com/photo-1524492412937-b28074a5d7da?w=600',
        'highlights': ['Taj Mahal visit', 'Agra Fort tour', 'AC sedan cab', 'Professional guide'],
      },
      {
        'title': 'Jaipur to Ajmer-Pushkar',
        'location': 'Ajmer',
        'duration': 'Full Day',
        'price': '\₹3,500',
        'rating': '4.8',
        'image': 'https://images.unsplash.com/photo-1548013146-72479768bada?w=600',
        'highlights': ['Ajmer Sharif Dargah', 'Pushkar Lake', 'Brahma Temple', 'Local market'],
      },
    ];

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Text(
                'Featured Tour Packages',
                style: TextStyle(
                  fontSize: isMobile ? 28 : 36,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1A1F36),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Handpicked destinations for your next adventure',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 50),
              ResponsiveLayout(
                mobile: Column(
                  children: packages.map((p) => Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: _packageCard(context, p),
                  )).toList(),
                ),
                tablet: LayoutBuilder(
                  builder: (context, constraints) => Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    children: packages.map((p) => SizedBox(
                      width: (constraints.maxWidth - 20) / 2,
                      child: _packageCard(context, p),
                    )).toList(),
                  ),
                ),
                desktop: Row(
                  children: packages.map((p) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: _packageCard(context, p),
                    ),
                  )).toList(),
                ),
              ),
              const SizedBox(height: 40),
              TextButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PackagesPage()),
                ),
                icon: const Text(
                  'View All Packages',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                label: const Icon(Icons.arrow_forward, size: 18),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF1A1F36),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  side: BorderSide(color: Colors.grey[300]!),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _packageCard(BuildContext context, Map<String, dynamic> package) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Stack(
              children: [
                Image.network(
                  package['image']!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.star, color: AppConstants.accentColor, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          package['rating']!,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppConstants.primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      package['duration']!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  package['title']!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1F36),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text(
                      package['location']!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      'From ',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      package['price']!,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppConstants.primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...(package['highlights'] as List<String>).take(3).map((h) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, size: 12, color: Colors.green[600]),
                      const SizedBox(width: 6),
                      Text(
                        h,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )).toList(),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF1A1F36),
                          side: BorderSide(color: Colors.grey[300]!),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('View Details'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookingPage(selectedPackage: package['title']),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppConstants.primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          elevation: 0,
                        ),
                        child: const Text('Book Now'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF0D8BFF),
            Color(0xFF00A8E8),
            Color(0xFF00C853),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            children: [
              Text(
                'Ready for Your Next Adventure?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isMobile ? 28 : 36,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Book your dream vacation today and create memories that last a lifetime',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _GradientButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PackagesPage()),
                    ),
                    text: 'Browse Packages',
                    icon: Icons.arrow_forward,
                  ),
                  if (!isMobile) ...[
                    const SizedBox(width: 16),
                    _OutlinedWhiteButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const BookingPage()),
                      ),
                      text: 'Book Now',
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF1A1F36),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(gradient: AppConstants.primaryGradient),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.flight_takeoff, color: AppConstants.primaryColor, size: 20),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TravelExplore',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          'Your Journey Begins',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          _drawerItem(context, 'Home', const HomePage()),
          _drawerItem(context, 'Packages', const PackagesPage()),
          _drawerItem(context, 'Cab Booking', const BookingPage()),
          _drawerItem(context, 'Contact', const ContactPage()),
          _drawerItem(context, 'Feedback', const FeedbackPage()),
        ],
      ),
    );
  }

  Widget _drawerItem(BuildContext context, String title, Widget page) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => page),
      ),
    );
  }
}

// New Button Components
class _GradientButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final IconData icon;

  const _GradientButton({
    required this.onPressed,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.white, Colors.white],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text,
                style: const TextStyle(
                  color: AppConstants.primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              const SizedBox(width: 8),
              Icon(icon, color: AppConstants.primaryColor, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

class _OutlinedWhiteButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const _OutlinedWhiteButton({
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            text,
            style: const TextStyle(
              color: AppConstants.primaryColor,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}

// Custom Scalable Button without standard styling limits
class _AnimatedScaleButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;

  const _AnimatedScaleButton({required this.onPressed, required this.child});

  @override
  State<_AnimatedScaleButton> createState() => _AnimatedScaleButtonState();
}

class _AnimatedScaleButtonState extends State<_AnimatedScaleButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedScale(
          scale: _isHovered ? 1.05 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: widget.child,
        ),
      ),
    );
  }
}

class _AnimatedButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;

  const _AnimatedButton({required this.onPressed, required this.child});

  @override
  State<_AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<_AnimatedButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: ElevatedButton(onPressed: widget.onPressed, child: widget.child),
      ),
    );
  }
}

class _HoverCard extends StatefulWidget {
  final Widget child;

  const _HoverCard({required this.child});

  @override
  State<_HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<_HoverCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _isHovered ? -15 : 0, 0),
        child: widget.child,
      ),
    );
  }
}

class _AnimatedOutlinedButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;

  const _AnimatedOutlinedButton({required this.onPressed, required this.child});

  @override
  State<_AnimatedOutlinedButton> createState() =>
      _AnimatedOutlinedButtonState();
}

class _AnimatedOutlinedButtonState extends State<_AnimatedOutlinedButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: OutlinedButton(
          onPressed: widget.onPressed,
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.white, width: 2),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
