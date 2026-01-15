import 'package:flutter/material.dart';
import 'package:lowgo_cab/utils/constants.dart';
import 'package:lowgo_cab/widgets/custom_header.dart';
import 'package:lowgo_cab/widgets/custom_footer.dart';
import 'package:lowgo_cab/widgets/responsive_layout.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomHeader(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildModernHero(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: ResponsiveLayout(
                    mobile: Column(
                      children: [
                        _buildContactInfo(),
                        const SizedBox(height: 60),
                        _buildContactForm(),
                      ],
                    ),
                    desktop: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 4, child: _buildContactInfo()),
                        const SizedBox(width: 80),
                        Expanded(flex: 6, child: _buildContactForm()),
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

  Widget _buildModernHero() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 24),
      decoration: const BoxDecoration(gradient: AppConstants.primaryGradient),
      child: const Column(
        children: [
          Text(
            'GET IN TOUCH',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 3,
              fontSize: 12,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Contact Our Support Team',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              height: 1.1,
            ),
          ),
          SizedBox(height: 24),
          Text(
            'We are here to help you 24/7 with your travel needs.',
            style: TextStyle(fontSize: 18, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Contact Information',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 20),
        const Text(
          'Fill out the form and our team will get back to you within 24 hours. Or use our direct contact channels below.',
          style: TextStyle(color: Colors.grey, height: 1.6, fontSize: 16),
        ),
        const SizedBox(height: 48),
        _infoCard(
          Icons.location_on_rounded,
          'Main Office',
          'Amer Road, Jaipur, Rajasthan, India',
        ),
        _infoCard(
          Icons.phone_in_talk_rounded,
          'Call Us',
          AppConstants.whatsappNumber,
        ),
        _infoCard(
          Icons.email_rounded,
          'Mail Support',
          AppConstants.contactEmail,
        ),
        const SizedBox(height: 48),
        const Text(
          'Connect with Us',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            _socialButton(FontAwesomeIcons.facebookF),
            _socialButton(FontAwesomeIcons.twitter),
            _socialButton(FontAwesomeIcons.instagram),
            _socialButton(FontAwesomeIcons.whatsapp),
          ],
        ),
      ],
    );
  }

  Widget _infoCard(IconData icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppConstants.surfaceColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Icon(icon, color: AppConstants.primaryColor),
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
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _socialButton(IconData icon) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: IconButton(
        onPressed: () {},
        icon: FaIcon(icon),
        color: AppConstants.secondaryColor,
        style: IconButton.styleFrom(
          backgroundColor: AppConstants.surfaceColor,
          padding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _buildContactForm() {
    return Container(
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 50,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Message Us',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 32),
          _field('Full Name', Icons.person_outline),
          const SizedBox(height: 20),
          _field('Email Address', Icons.email_outlined),
          const SizedBox(height: 20),
          _field('Phone Number', Icons.phone_android_outlined),
          const SizedBox(height: 20),
          _field('Your Message', Icons.chat_bubble_outline, maxLines: 5),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 22),
              ),
              child: const Text(
                'SEND MESSAGE NOW',
                style: TextStyle(letterSpacing: 1.2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(String label, IconData icon, {int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
      ),
    );
  }
}
