import 'package:flutter/material.dart';
import 'package:lowgo_cab/utils/constants.dart';
import 'package:lowgo_cab/views/home_page.dart';
import 'package:lowgo_cab/views/packages_page.dart';
import 'package:lowgo_cab/views/about_page.dart';
import 'package:lowgo_cab/views/contact_page.dart';
import 'package:lowgo_cab/widgets/responsive_layout.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomHeader extends StatelessWidget implements PreferredSizeWidget {
  const CustomHeader({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(120); // Taller for dual bar

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);

    return Column(
      children: [
        // Top Bar (Magenta)
        Container(
          height: isMobile ? 40 : 50,
          color: AppConstants.topBarColor,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.email, color: Colors.white, size: 16),
                      const SizedBox(width: 8),
                      const Text(
                        'support@lowgocab.com',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      if (!isMobile) ...[
                        const SizedBox(width: 24),
                        const Icon(Icons.phone, color: Colors.white, size: 16),
                        const SizedBox(width: 8),
                        const Text(
                          '+91 98765 43210',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ],
                  ),
                  Row(
                    children: [
                      _socialIcon(FontAwesomeIcons.facebookF),
                      _socialIcon(FontAwesomeIcons.twitter),
                      _socialIcon(FontAwesomeIcons.instagram),
                      _socialIcon(FontAwesomeIcons.linkedinIn),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        // Main Header
        Container(
          height: isMobile ? 60 : 70,
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo
                  GestureDetector(
                    onTap: () => Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const HomePage()),
                      (route) => false,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.local_taxi,
                          size: 32,
                          color: AppConstants.primaryColor,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'LOWGO CAB',
                          style: TextStyle(
                            fontSize: isMobile ? 20 : 26,
                            fontWeight: FontWeight.w900,
                            color: AppConstants.secondaryColor,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (!isMobile)
                    Row(
                      children: [
                        _buildNavLink(context, 'HOME', const HomePage()),
                        _buildNavLink(context, 'ABOUT US', const AboutPage()),
                        _buildNavLink(
                          context,
                          'PACKAGES',
                          const PackagesPage(),
                        ),
                        _buildNavLink(
                          context,
                          'CONTACT US',
                          const ContactPage(),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppConstants.primaryColor,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                          child: const Text(
                            'ENQUIRY NOW',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    )
                  else
                    IconButton(
                      icon: const Icon(
                        Icons.menu,
                        color: AppConstants.secondaryColor,
                      ),
                      onPressed: () => Scaffold.of(context).openEndDrawer(),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _socialIcon(IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: FaIcon(icon, color: Colors.white, size: 14),
    );
  }

  Widget _buildNavLink(BuildContext context, String title, Widget page) {
    return TextButton(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => page),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: AppConstants.secondaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}
