import 'package:flutter/material.dart';
import 'package:lowgo_cab/utils/constants.dart';
import 'package:lowgo_cab/views/home_page.dart';
import 'package:lowgo_cab/views/packages_page.dart';
import 'package:lowgo_cab/views/contact_page.dart';
import 'package:lowgo_cab/views/feedback_page.dart';
import 'package:lowgo_cab/views/booking_page.dart';
import 'package:lowgo_cab/widgets/responsive_layout.dart';

class CustomHeader extends StatelessWidget implements PreferredSizeWidget {
  final String? currentPage;
  const CustomHeader({super.key, this.currentPage});

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);

    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => _navigateTo(context, const HomePage()),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: AppConstants.blueGradient,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.flight_takeoff,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'TravelExplore',
                            style: TextStyle(
                              fontSize: isMobile ? 16 : 18,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF1A1F36),
                              letterSpacing: -0.5,
                            ),
                          ),
                          Text(
                            'Your Journey Begins',
                            style: TextStyle(
                              fontSize: isMobile ? 9 : 10,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              if (!isMobile)
                Row(
                  children: [
                    _NavPill(
                      title: 'Home',
                      page: const HomePage(),
                      isActive: currentPage == 'home',
                    ),
                    _NavPill(
                      title: 'Packages',
                      page: const PackagesPage(),
                      isActive: currentPage == 'packages',
                    ),
                    _NavPill(
                      title: 'Cab Booking',
                      page: const BookingPage(),
                      isActive: currentPage == 'booking',
                    ),
                    _NavPill(
                      title: 'Contact',
                      page: const ContactPage(),
                      isActive: currentPage == 'contact',
                    ),
                    _NavPill(
                      title: 'Feedback',
                      page: const FeedbackPage(),
                      isActive: currentPage == 'feedback',
                    ),
                  ],
                )
              else
                Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(
                      Icons.menu_rounded,
                      color: Color(0xFF1A1F36),
                      size: 26,
                    ),
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => page),
      (route) => false,
    );
  }
}

/// Navigation pill with gradient active state
class _NavPill extends StatefulWidget {
  final String title;
  final Widget page;
  final bool isActive;

  const _NavPill({
    required this.title,
    required this.page,
    this.isActive = false,
  });

  @override
  State<_NavPill> createState() => _NavPillState();
}

class _NavPillState extends State<_NavPill> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => widget.page),
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: widget.isActive ? AppConstants.primaryGradient : null,
            color: widget.isActive ? null : (_isHovered ? Colors.grey[100] : Colors.transparent),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            widget.title,
            style: TextStyle(
              color: widget.isActive
                  ? Colors.white
                  : (_isHovered ? AppConstants.primaryColor : const Color(0xFF1A1F36)),
              fontWeight: widget.isActive ? FontWeight.w600 : FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
