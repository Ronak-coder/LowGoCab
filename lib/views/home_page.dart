import 'package:flutter/material.dart';
import 'package:lowgo_cab/utils/constants.dart';
import 'package:lowgo_cab/views/packages_page.dart';
import 'package:lowgo_cab/views/contact_page.dart';
import 'package:lowgo_cab/widgets/responsive_layout.dart';
import 'package:lowgo_cab/widgets/custom_header.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lowgo_cab/widgets/custom_footer.dart';
import 'package:lowgo_cab/views/about_page.dart';
import 'booking_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomHeader(),
      endDrawer: _buildDrawer(context),
      floatingActionButton: _buildFloatingWhatsApp(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _fadeIn(child: _buildModernHero(context), delay: 0),
            _fadeIn(child: _buildStatsRow(context), delay: 200),
            _fadeIn(child: _buildAboutModern(context), delay: 400),
            _fadeIn(child: _buildServiceHighlights(context), delay: 600),
            _fadeIn(child: _buildCallToAction(context), delay: 800),
            const CustomFooter(),
          ],
        ),
      ),
    );
  }

  Widget _fadeIn({required Widget child, int delay = 0}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 800 + delay),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  Widget _buildFloatingWhatsApp() {
    return FloatingActionButton.extended(
      onPressed: () => launchUrl(
        Uri.parse(
          'https://wa.me/${AppConstants.whatsappNumber.replaceAll('+', '')}',
        ),
      ),
      backgroundColor: const Color(0xFF25D366),
      icon: const FaIcon(FontAwesomeIcons.whatsapp, color: Colors.white),
      label: const Text(
        'Chat with Us',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildModernHero(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);
    return Container(
      width: double.infinity,
      height: isMobile ? 600 : 800,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            'https://images.unsplash.com/photo-1485291571150-772bcfc10da5?w=1600', // Premium sedan image
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black.withOpacity(0.7),
              Colors.transparent,
              Colors.black.withOpacity(0.7),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1000),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppConstants.primaryColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    'TAXI SERVICE IN JAIPUR',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Expert Local & \nOutstation Travel',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isMobile ? 48 : 84,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1.0,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Premium Cars, Professional Drivers, Best Prices Guaranteed.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, color: Colors.white70),
                ),
                const SizedBox(height: 48),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PackagesPage(),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.primaryColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 24,
                        ),
                      ),
                      child: const Text(
                        'BOOK YOUR RIDE',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    if (!isMobile) ...[
                      const SizedBox(width: 20),
                      OutlinedButton(
                        onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PackagesPage(),
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white, width: 2),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 24,
                          ),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text(
                          'OUR PACKAGES',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -50),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1100),
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 40,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _statItem('5000+', 'Happy Clients'),
              _statItem('150+', 'Verified Drivers'),
              _statItem('24/7', 'Support Available'),
              if (!ResponsiveLayout.isMobile(context))
                _statItem('100%', 'Safe Guarantee'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: AppConstants.primaryColor,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildAboutModern(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: ResponsiveLayout(
            mobile: Column(children: _aboutContent(isMobile, context)),
            desktop: Row(children: _aboutContent(isMobile, context)),
          ),
        ),
      ),
    );
  }

  List<Widget> _aboutContent(bool isMobile, BuildContext context) {
    return [
      Expanded(
        flex: isMobile ? 0 : 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'WHO WE ARE',
              style: TextStyle(
                color: AppConstants.primaryColor,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Jaipur\'s Most Trusted \nTravel Partner',
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.w900,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'LowGo Cab is dedicated to providing high-quality transportation solutions that are both affordable and reliable. Whether you need a quick airport transfer or a multi-day Rajasthan tour, we are here to serve you.',
              style: TextStyle(fontSize: 16, color: Colors.grey, height: 1.6),
            ),
            const SizedBox(height: 32),
            _featureList('Certified Professional Drivers'),
            _featureList('Wide Range of Transparent Pricing'),
            _featureList('Zero Hidden Charges'),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AboutPage()),
              ),
              child: const Text('DISCOVER OUR STORY'),
            ),
          ],
        ),
      ),
      if (!isMobile) const SizedBox(width: 80),
      Expanded(
        flex: isMobile ? 0 : 5,
        child: Container(
          height: 500,
          margin: EdgeInsets.only(top: isMobile ? 40 : 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            image: const DecorationImage(
              image: NetworkImage(
                'https://images.unsplash.com/photo-1598254823903-88746ac5fbc6?w=800', // Jaipur Hawa Mahal image
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    ];
  }

  Widget _featureList(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            color: AppConstants.primaryColor,
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceHighlights(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppConstants.surfaceColor,
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 24),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              const Text(
                'OUR SERVICES',
                style: TextStyle(
                  color: AppConstants.primaryColor,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Premium Travel Solutions',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 60),
              ResponsiveLayout(
                mobile: _serviceGrid(1),
                tablet: _serviceGrid(2),
                desktop: _serviceGrid(3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _serviceGrid(int count) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: count,
      crossAxisSpacing: 30,
      mainAxisSpacing: 30,
      childAspectRatio: 1.2,
      children: [
        _serviceCard(
          Icons.location_city,
          'City Sightseeing',
          'Explore monuments with ease.',
        ),
        _serviceCard(
          Icons.flight,
          'Airport Transfers',
          'On-time pickup & drop.',
        ),
        _serviceCard(
          Icons.map,
          'Outstation Trips',
          'Safe long distance travel.',
        ),
      ],
    );
  }

  Widget _serviceCard(IconData icon, String title, String desc) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: AppConstants.primaryColor),
          const SizedBox(height: 24),
          Text(
            title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 12),
          Text(desc, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildCallToAction(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 24),
      decoration: const BoxDecoration(gradient: AppConstants.primaryGradient),
      child: Column(
        children: [
          const Text(
            'READY TO GO?',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Your Premium Ride is Just a \nWhatsApp Message Away!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 42,
              fontWeight: FontWeight.w900,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 48),
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BookingPage()),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppConstants.primaryColor,
            ),
            child: const Text('GET A QUOTE NOW'),
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
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            ),
          ),
          ListTile(
            title: const Text('TOUR PACKAGES'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PackagesPage()),
            ),
          ),
          ListTile(
            title: const Text('CONTACT US'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ContactPage()),
            ),
          ),
        ],
      ),
    );
  }
}
