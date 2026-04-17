import 'package:flutter/material.dart';
import 'package:lowgo_cab/utils/constants.dart';
import 'package:lowgo_cab/views/home_page.dart';
import 'package:lowgo_cab/views/packages_page.dart';
import 'package:lowgo_cab/views/contact_page.dart';
import 'package:lowgo_cab/views/feedback_page.dart';
import 'package:lowgo_cab/views/booking_page.dart';

class CustomFooter extends StatelessWidget {
  const CustomFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1A1F36),
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 700) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _footerBrand(),
                        const SizedBox(height: 40),
                        _footerLinks(context, 'Quick Links'),
                        const SizedBox(height: 40),
                        _footerDestinations(),
                        const SizedBox(height: 40),
                        _footerContact(),
                      ],
                    );
                  }
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 3, child: _footerBrand()),
                      const SizedBox(width: 40),
                      Expanded(flex: 2, child: _footerLinks(context, 'Quick Links')),
                      const SizedBox(width: 40),
                      Expanded(flex: 2, child: _footerDestinations()),
                      const SizedBox(width: 40),
                      Expanded(flex: 3, child: _footerContact()),
                    ],
                  );
                },
              ),
              const SizedBox(height: 50),
              Divider(
                color: Colors.white.withOpacity(0.1),
                height: 1,
              ),
              const SizedBox(height: 24),
              Text(
                '© ${DateTime.now().year} TravelExplore. All rights reserved. Made with ❤️ for travelers.',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _footerBrand() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: AppConstants.blueGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.flight_takeoff, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            const Text(
              'TravelExplore',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 20,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Your trusted partner for unforgettable travel experiences. Explore the world with us!',
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            height: 1.6,
            fontSize: 14,
          ),
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
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 20),
        _FooterLinkItem(title: 'Home', page: const HomePage()),
        _FooterLinkItem(title: 'Packages', page: const PackagesPage()),
        _FooterLinkItem(title: 'Cab Booking', page: const BookingPage()),
        _FooterLinkItem(title: 'Contact', page: const ContactPage()),
        _FooterLinkItem(title: 'Feedback', page: const FeedbackPage()),
      ],
    );
  }

  Widget _footerDestinations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Popular Destinations',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 20),
        _destinationItem('Maldives'),
        _destinationItem('Paris, France'),
        _destinationItem('Dubai, UAE'),
        _destinationItem('Swiss Alps'),
        _destinationItem('Bali, Indonesia'),
      ],
    );
  }

  Widget _destinationItem(String name) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        name,
        style: TextStyle(
          color: Colors.white.withOpacity(0.6),
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _footerContact() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Contact Us',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 20),
        _contactRow(Icons.phone_outlined, '+1 (555) 123-4567'),
        const SizedBox(height: 12),
        _contactRow(Icons.email_outlined, 'info@travelexplore.com'),
        const SizedBox(height: 12),
        _contactRow(Icons.location_on_outlined, '123 Travel Street, NY 10001'),
      ],
    );
  }

  Widget _contactRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.5), size: 16),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}

class _FooterLinkItem extends StatefulWidget {
  final String title;
  final Widget page;

  const _FooterLinkItem({required this.title, required this.page});

  @override
  State<_FooterLinkItem> createState() => _FooterLinkItemState();
}

class _FooterLinkItemState extends State<_FooterLinkItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => widget.page),
          ),
          child: Text(
            widget.title,
            style: TextStyle(
              color: _isHovered ? Colors.white : Colors.white.withOpacity(0.6),
              fontSize: 14,
              fontWeight: _isHovered ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
