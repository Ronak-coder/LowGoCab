import 'package:flutter/material.dart';
import 'package:lowgo_cab/utils/constants.dart';
import 'package:lowgo_cab/widgets/custom_header.dart';
import 'package:lowgo_cab/widgets/custom_footer.dart';
import 'package:lowgo_cab/widgets/responsive_layout.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomHeader(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildModernHero(),
            _buildAboutStory(context),
            _buildCoreValues(context),
            _buildCallToAction(context),
            const CustomFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildModernHero() {
    return Container(
      width: double.infinity,
      height: 450,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            'https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?w=1600',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black.withOpacity(0.4),
              Colors.black.withOpacity(0.8),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'LEARN MORE',
                style: TextStyle(
                  color: AppConstants.accentColor,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'About LowGo Cab',
                style: TextStyle(
                  fontSize: 56,
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

  Widget _buildAboutStory(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 24),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: ResponsiveLayout(
            mobile: Column(children: _storyContent(isMobile)),
            desktop: Row(children: _storyContent(isMobile)),
          ),
        ),
      ),
    );
  }

  List<Widget> _storyContent(bool isMobile) {
    return [
      Expanded(
        flex: isMobile ? 0 : 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'OUR STORY',
              style: TextStyle(
                color: AppConstants.primaryColor,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Driven by Reliability, \nDefined by Quality.',
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.w900,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'LowGo Cab started with a vision to redefine the travel experience in Jaipur. We recognized the need for a service that combines the luxury of premium vehicles with the affordability of local cabs.',
              style: TextStyle(fontSize: 18, color: Colors.grey, height: 1.7),
            ),
            const SizedBox(height: 24),
            const Text(
              'Today, we stand as one of the highest-rated cab services in Rajasthan, serving thousands of tourists and locals every month with a dedicated fleet of professional drivers.',
              style: TextStyle(fontSize: 18, color: Colors.grey, height: 1.7),
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
                'https://images.unsplash.com/photo-1599661046289-e31897856741?w=1000',
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    ];
  }

  Widget _buildCoreValues(BuildContext context) {
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
                'CORE VALUES',
                style: TextStyle(
                  color: AppConstants.primaryColor,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'What Makes Us Different',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 60),
              ResponsiveLayout(
                mobile: _valueGrid(1),
                tablet: _valueGrid(2),
                desktop: _valueGrid(3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _valueGrid(int count) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: count,
      crossAxisSpacing: 30,
      mainAxisSpacing: 30,
      childAspectRatio: 1.3,
      children: [
        _valueCard(
          Icons.verified_user_outlined,
          'Safety First',
          'Rigorous driver background checks & live tracking.',
        ),
        _valueCard(
          Icons.payments_outlined,
          'Lowest Rates',
          'Transparent pricing with no hidden tourist surcharges.',
        ),
        _valueCard(
          Icons.support_agent_outlined,
          '24/7 Support',
          'Dedicated team available to assist your journey at any time.',
        ),
      ],
    );
  }

  Widget _valueCard(IconData icon, String title, String desc) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 40, color: AppConstants.primaryColor),
          const SizedBox(height: 24),
          Text(
            title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 12),
          Text(desc, style: const TextStyle(color: Colors.grey, height: 1.5)),
        ],
      ),
    );
  }

  Widget _buildCallToAction(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppConstants.secondaryColor, Color(0xFF333333)],
        ),
      ),
      child: Column(
        children: [
          const Text(
            'EXPERIENCE THE DIFFERENCE',
            style: TextStyle(
              color: AppConstants.accentColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Ready to Book Your Royale Journey?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 48),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
            ),
            child: const Text('CONTACT US TODAY'),
          ),
        ],
      ),
    );
  }
}
