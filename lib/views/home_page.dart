import 'package:flutter/material.dart';
import 'package:lowgo_cab/utils/constants.dart';
import 'package:lowgo_cab/views/packages_page.dart';
import 'package:lowgo_cab/views/about_page.dart';
import 'package:lowgo_cab/views/contact_page.dart';
import 'package:lowgo_cab/widgets/responsive_layout.dart';
import 'package:lowgo_cab/widgets/custom_header.dart';
import 'booking_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomHeader(),
      endDrawer: _buildDrawer(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeroSection(context),
            _buildAboutQuick(context),
            _buildTourPackagesSection(context),
            _buildTaxiPricingSection(context),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: AppConstants.primaryColor),
            child: const Column(
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
                Text(
                  'Premium Sightseeing & Rentals',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          _drawerItem(context, Icons.home, 'HOME', const HomePage()),
          _drawerItem(context, Icons.info, 'ABOUT US', const AboutPage()),
          _drawerItem(
            context,
            Icons.local_offer,
            'TOUR PACKAGES',
            const PackagesPage(),
          ),
          _drawerItem(
            context,
            Icons.contact_support,
            'CONTACT US',
            const ContactPage(),
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(
    BuildContext context,
    IconData icon,
    String title,
    Widget page,
  ) {
    return ListTile(
      leading: Icon(icon, color: AppConstants.primaryColor),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = ResponsiveLayout.isMobile(context);

    return Container(
      width: double.infinity,
      height: isMobile ? size.height * 0.7 : size.height * 0.85,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            'https://images.unsplash.com/photo-1599661046289-e31897856741?w=1600',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1200),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'SIGHTSEEING CAB IN JAIPUR',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isMobile ? 36 : 72,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'RELIABLE TAXI SERVICES FOR LOCAL & OUTSTATION TRIPS',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isMobile ? 16 : 24,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 40),
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
                    'EXPLORE PACKAGES',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAboutQuick(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: ResponsiveLayout(
            mobile: Column(children: _aboutContent(context, isMobile)),
            desktop: Row(children: _aboutContent(context, isMobile)),
          ),
        ),
      ),
    );
  }

  List<Widget> _aboutContent(BuildContext context, bool isMobile) {
    return [
      isMobile ? _aboutTextColumn() : Expanded(child: _aboutTextColumn()),
      SizedBox(width: isMobile ? 0 : 60, height: isMobile ? 40 : 0),
      isMobile ? _aboutImage() : Expanded(child: _aboutImage()),
    ];
  }

  Widget _aboutTextColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'WELCOME TO LOWGO CAB',
          style: TextStyle(
            color: AppConstants.primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Your Trusted Partner for Jaipur Sightseeing',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: AppConstants.secondaryColor,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'LowGo Cab is the leading provider of personalized tour packages and cab rental services in Jaipur. We offer a wide range of well-maintained vehicles and experienced drivers to ensure your journey is safe, comfortable, and memorable.',
          style: TextStyle(fontSize: 16, color: Colors.grey[700], height: 1.6),
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: () {},
          child: const Text('READ MORE ABOUT US'),
        ),
      ],
    );
  }

  Widget _aboutImage() {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: const DecorationImage(
          image: NetworkImage(
            'https://images.unsplash.com/photo-1524492412937-b28074a5d7da?w=800',
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildTourPackagesSection(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.grey[50],
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              _sectionTitle('JAIPUR TOUR PACKAGES'),
              const Text(
                'Explore the beauty of the Pink City with our curated one-day and multi-day tours.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              _buildSimpleTourGrid(context),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PackagesPage()),
                ),
                child: const Text('VIEW ALL PACKAGES'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSimpleTourGrid(BuildContext context) {
    return const Column(
      children: [Text("Please see the Packages page for full tour listings.")],
    );
  }

  Widget _buildTaxiPricingSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 24),
      child: const Column(
        children: [
          Text("CAB RENTALS STARTING FROM ₹11/KM"),
          SizedBox(height: 20),
          Text(
            "Sedans, MPVs, and Mini Buses available for all your travel needs.",
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Container(width: 80, height: 4, color: AppConstants.primaryColor),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      color: AppConstants.secondaryColor,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _footerColumn(
                    'ABOUT US',
                    'LowGo Cab is Jaipur\'s most reliable car rental service, offering affordable and high-quality sightseeing tours across Rajasthan.',
                  ),
                  _footerColumn(
                    'QUICK LINKS',
                    'Home\nAbout Us\nPackages\nContact Us\nTerms & Conditions',
                  ),
                  _footerColumn(
                    'CONTACT US',
                    'Amer Road, Jaipur, Rajasthan\n+91 98765 43210\nsupport@lowgocab.com',
                  ),
                ],
              ),
              const SizedBox(height: 60),
              const Divider(color: Colors.white10),
              const SizedBox(height: 40),
              const Text(
                '© 2026 LOWGO CAB. ALL RIGHTS RESERVED.',
                style: TextStyle(color: Colors.white24, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _footerColumn(String title, String content) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              content,
              style: const TextStyle(color: Colors.white60, height: 1.6),
            ),
          ],
        ),
      ),
    );
  }
}
