import 'package:flutter/material.dart';
import 'package:lowgo_cab/utils/constants.dart';
import 'package:lowgo_cab/views/home_page.dart';
import 'package:lowgo_cab/views/packages_page.dart';
import 'package:lowgo_cab/views/contact_page.dart';
import 'package:lowgo_cab/views/about_page.dart';
import 'package:lowgo_cab/views/feedback_page.dart';

class CustomFooter extends StatelessWidget {
  const CustomFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppConstants.secondaryColor,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 600) {
                    return Column(
                      children: [
                        _footerColumn(
                          'ABOUT US',
                          'LowGo Cab is Jaipur\'s most reliable car rental service, offering affordable and high-quality sightseeing tours across Rajasthan.',
                        ),
                        const SizedBox(height: 40),
                        _footerLinks(context, 'QUICK LINKS'),
                        const SizedBox(height: 40),
                        _footerColumn(
                          'CONTACT US',
                          'Anupam Apartment A2/312, Pratap Nagar, Jaipur, Rajasthan\n${AppConstants.whatsappNumber}\n${AppConstants.displayEmail}',
                        ),
                      ],
                    );
                  }
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _footerColumn(
                          'ABOUT US',
                          'LowGo Cab is Jaipur\'s most reliable car rental service, offering affordable and high-quality sightseeing tours across Rajasthan.',
                        ),
                      ),
                      const SizedBox(width: 40),
                      Expanded(child: _footerLinks(context, 'QUICK LINKS')),
                      const SizedBox(width: 40),
                      Expanded(
                        child: _footerColumn(
                          'CONTACT US',
                          'Anupam Apartment A2/312, Pratap Nagar, Jaipur, Rajasthan\n${AppConstants.whatsappNumber}\n${AppConstants.displayEmail}',
                        ),
                      ),
                    ],
                  );
                },
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
    return Column(
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
    );
  }

  Widget _footerLinks(BuildContext context, String title) {
    return Column(
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
        _linkItem(context, 'Home', const HomePage()),
        _linkItem(context, 'About Us', const AboutPage()),
        _linkItem(context, 'Packages', const PackagesPage()),
        _linkItem(context, 'Contact Us', const ContactPage()),
        _linkItem(context, 'Feedback', const FeedbackPage()),
      ],
    );
  }

  Widget _linkItem(BuildContext context, String title, Widget page) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => page),
        ),
        child: Text(
          title,
          style: const TextStyle(color: Colors.white60, fontSize: 14),
        ),
      ),
    );
  }
}
