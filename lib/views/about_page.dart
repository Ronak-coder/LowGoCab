import 'package:flutter/material.dart';
import 'package:lowgo_cab/utils/constants.dart';
import 'package:lowgo_cab/widgets/custom_header.dart';
import 'package:lowgo_cab/widgets/custom_footer.dart';
import 'package:lowgo_cab/widgets/responsive_layout.dart';
import 'package:lowgo_cab/views/contact_page.dart';
import 'package:lowgo_cab/views/home_page.dart';
import 'dart:ui';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> with TickerProviderStateMixin {
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
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: const CustomHeader(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildPremiumHero(isMobile),
            _buildAboutStory(context, isMobile),
            _buildCoreValues(context, isMobile),
            _buildHistorySection(isMobile),
            _buildCallToAction(context, isMobile),
            const CustomFooter(),
          ],
        ),
      ),
    );
  }

  Widget _fadeIn({required Widget child, double delay = 0.0}) {
    final animation = CurvedAnimation(
      parent: _contentController,
      curve: Interval(delay, 1.0, curve: Curves.easeOutCubic),
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
      height: isMobile ? 400 : 550,
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
              Colors.black.withOpacity(0.6),
              AppConstants.backgroundColor.withOpacity(0.95),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _fadeIn(
                delay: 0.1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.white.withOpacity(0.2)),
                      ),
                      child: const Text(
                        'DRIVEN BY PASSION',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _fadeIn(
                delay: 0.3,
                child: Text(
                  'Our Journey',
                  style: TextStyle(
                    fontSize: isMobile ? 48 : 72,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAboutStory(BuildContext context, bool isMobile) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 60 : 120,
        horizontal: 24,
      ),
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
        child: _fadeIn(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppConstants.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'OUR STORY',
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
                'Redefining Travel in the Pink City',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  color: AppConstants.secondaryColor,
                  height: 1.2,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'LowGo Cab was born in 2025 with a simple goal: to provide affordable luxury to every traveler in Jaipur. We bridge the gap between expensive private rentals and inconsistent local options.',
                style: TextStyle(fontSize: 18, color: Colors.black54, height: 1.8),
              ),
              const SizedBox(height: 24),
              const Text(
                'With a growing fleet of modern vehicles and professional chauffeurs, we have quickly become Jaipur\'s trusted name for sightseeing, outstation trips, and airport transfers.',
                style: TextStyle(fontSize: 18, color: Colors.black54, height: 1.8),
              ),
            ],
          ),
        ),
      ),
      if (!isMobile) const SizedBox(width: 80),
      Expanded(
        flex: isMobile ? 0 : 5,
        child: _fadeIn(
          delay: 0.2,
          child: Container(
            height: 500,
            margin: EdgeInsets.only(top: isMobile ? 60 : 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              image: const DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1599661046289-e31897856741?w=1000',
                ),
                fit: BoxFit.cover,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 50,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
          ),
        ),
      ),
    ];
  }

  Widget _buildCoreValues(BuildContext context, bool isMobile) {
    return Container(
      width: double.infinity,
      color: AppConstants.surfaceColor,
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 24),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppConstants.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'CORE VALUES',
                  style: TextStyle(
                    color: AppConstants.primaryColor,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Built on Trust & Reliability',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 42,
                  color: AppConstants.secondaryColor,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                ),
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
      childAspectRatio: 1.1,
      children: [
        _HoverValueCard(
          icon: Icons.verified_user_outlined,
          title: 'Safety First',
          desc: 'Every chauffeur is thoroughly background-verified for your peace of mind.',
        ),
        _HoverValueCard(
          icon: Icons.payments_outlined,
          title: 'Lowest Rates',
          desc: 'Premium luxury experience at prices that respect your budget.',
        ),
        _HoverValueCard(
          icon: Icons.auto_awesome_rounded,
          title: 'Modern Fleet',
          desc: 'All our vehicles are regularly maintained and kept in pristine condition.',
        ),
      ],
    );
  }

  Widget _buildHistorySection(bool isMobile) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 24),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppConstants.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'OUR MILESTONES',
              style: TextStyle(
                color: AppConstants.primaryColor,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 60),
          _historyItem(
            '2025',
            'Foundation',
            'Launched our first fleet of 10 hybrid sedans in Jaipur.',
          ),
          _historyItem(
            'Present',
            'Rapid Growth',
            'Managing over 100+ tours per month with 99% positive feedback.',
          ),
        ],
      ),
    );
  }

  Widget _historyItem(String year, String title, String desc) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 800),
      margin: const EdgeInsets.only(bottom: 50),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              year,
              style: const TextStyle(
                color: AppConstants.primaryColor,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 40),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 28,
                    color: AppConstants.secondaryColor,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  desc,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCallToAction(BuildContext context, bool isMobile) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 24),
      decoration: const BoxDecoration(
        color: AppConstants.secondaryColor,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: -50,
            right: -50,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppConstants.primaryColor.withOpacity(0.2),
                ),
              ),
            ),
          ),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: const Text(
                  'JOURNEY WITH US',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Experience Premium Travel Today',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 48),
              _fadeIn(
                child: ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ContactPage()),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 10,
                    shadowColor: AppConstants.primaryColor.withOpacity(0.5),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 56,
                      vertical: 24,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'CONTACT OUR TEAM',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
            ],
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

class _HoverValueCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String desc;

  const _HoverValueCard({
    required this.icon,
    required this.title,
    required this.desc,
  });

  @override
  State<_HoverValueCard> createState() => _HoverValueCardState();
}

class _HoverValueCardState extends State<_HoverValueCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _isHovered ? -10 : 0, 0),
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: Colors.grey.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_isHovered ? 0.08 : 0.03),
              blurRadius: _isHovered ? 40 : 20,
              offset: Offset(0, _isHovered ? 20 : 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _isHovered ? AppConstants.primaryColor : AppConstants.primaryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                widget.icon,
                size: 32,
                color: _isHovered ? Colors.white : AppConstants.primaryColor,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: AppConstants.secondaryColor,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.desc,
              style: const TextStyle(
                color: Colors.black54,
                height: 1.6,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
