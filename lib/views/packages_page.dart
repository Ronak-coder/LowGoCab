import 'package:flutter/material.dart';
import 'package:lowgo_cab/utils/constants.dart';
import 'package:lowgo_cab/widgets/responsive_layout.dart';
import 'package:lowgo_cab/widgets/custom_header.dart';
import 'package:lowgo_cab/widgets/custom_footer.dart';
import 'dart:ui';
import 'booking_page.dart';

class PackagesPage extends StatefulWidget {
  const PackagesPage({super.key});

  @override
  State<PackagesPage> createState() => _PackagesPageState();
}

class _PackagesPageState extends State<PackagesPage>
    with TickerProviderStateMixin {
  late AnimationController _contentController;

  final List<Map<String, dynamic>> tours = [
    {
      'title': 'One Day Jaipur Sightseeing Tour',
      'price': '₹1,500',
      'desc': 'Detailed tour of Amer Fort, Jal Mahal, Hawa Mahal and more.',
      'image': 'assets/images/JaipurTour.png',
      'duration': '12 Hours',
      'location': 'Jaipur City',
    },
    {
      'title': 'Jaipur to Khatu Shyam Ji',
      'price': '₹2,199',
      'desc':
          'One Day Trip from Jaipur to Khatu Shyam Ji Temple with Toll and Parking',
      'image': 'assets/images/jpr.png',
      'duration': '8 Hours',
      'location': 'Jaipur City',
    },
    {
      'title': 'Same Day Agra Tour From Jaipur',
      'price': '₹5,500',
      'desc': 'Visit the Taj Mahal and Agra Fort in a one day excursion.',
      'image':
          'https://images.unsplash.com/photo-1524492412937-b28074a5d7da?auto=format&fit=crop&q=80&w=800',
      'duration': 'Full Day',
      'location': 'Agra',
    },
  ];

  final List<Map<String, dynamic>> cabs = [
    {
      'model': 'Toyota Etios/Swift Dzire',
      'rate': '10/Km',
      'seats': '4',
      'type': 'Sedan',
      'image': 'assets/images/Dzire.png',
    },
    {
      'model': 'Maruti Ertiga',
      'rate': '13/Km',
      'seats': '5+1',
      'type': 'MPV',
      'image': 'assets/images/ertiga.png',
    },
    {
      'model': 'Toyota Innova',
      'rate': '16/Km',
      'seats': '6+1',
      'type': 'MPV',
      'image': 'assets/images/innova.png',
    },
    {
      'model': 'Toyota Crysta',
      'rate': '18/Km',
      'seats': '7+1',
      'type': 'Luxury MPV',
      'image': 'assets/images/innova.png',
    },
  ];

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

  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Budget', 'Mid-Range', 'Luxury'];

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: const CustomHeader(currentPage: 'packages'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildHeroSection(isMobile),
            const SizedBox(height: 40),
            _buildSearchAndFilter(isMobile),
            const SizedBox(height: 30),
            _buildPackagesGrid(context, isMobile),
            const SizedBox(height: 60),
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

  Widget _buildHeroSection(bool isMobile) {
    return Container(
      width: double.infinity,
      height: isMobile ? 280 : 350,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _fadeIn(
              delay: 0.1,
              child: Text(
                'Tour Packages',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isMobile ? 32 : 42,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 12),
            _fadeIn(
              delay: 0.2,
              child: Text(
                'Discover amazing destinations and create unforgettable memories',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: isMobile ? 14 : 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndFilter(bool isMobile) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1100),
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: isMobile
            ? Column(
                children: [
                  _searchField(),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _filters.map((f) => _filterChip(f)).toList(),
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(flex: 3, child: _searchField()),
                  const SizedBox(width: 20),
                  Row(
                    children: _filters.map((f) => _filterChip(f)).toList(),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _searchField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.grey[500], size: 20),
          const SizedBox(width: 12),
          Text(
            'Search destinations or packages...',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label) {
    final isSelected = _selectedFilter == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () => setState(() => _selectedFilter = label),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: isSelected ? AppConstants.primaryGradient : null,
            color: isSelected ? null : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: isSelected
                ? null
                : Border.all(color: Colors.grey[300]!),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey[700],
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPackagesGrid(BuildContext context, bool isMobile) {
    final packages = [
      {
        'title': 'One Day Jaipur Sightseeing Tour',
        'location': 'Jaipur City',
        'duration': '12 Hours',
        'price': '\₹1,500',
        'rating': '4.9',
        'reviews': '128',
        'image': 'https://images.unsplash.com/photo-1477587458883-47145ed94245?w=600',
        'highlights': ['Amer Fort tour', 'Hawa Mahal visit', 'Jal Mahal view', 'City Palace'],
      },
      {
        'title': 'Jaipur to Khatu Shyam Ji',
        'location': 'Jaipur City',
        'duration': '8 Hours',
        'price': '\₹2,199',
        'rating': '4.8',
        'reviews': '96',
        'image': 'https://images.unsplash.com/photo-1561361058-c24cecae35ca?w=600',
        'highlights': ['Temple darshan', 'AC cab included', 'Toll & parking', 'Pickup & drop'],
      },
      {
        'title': 'Same Day Agra Tour From Jaipur',
        'location': 'Agra',
        'duration': 'Full Day',
        'price': '\₹5,500',
        'rating': '4.7',
        'reviews': '156',
        'image': 'https://images.unsplash.com/photo-1524492412937-b28074a5d7da?w=600',
        'highlights': ['Taj Mahal visit', 'Agra Fort tour', 'AC sedan cab', 'Professional guide'],
      },
      {
        'title': 'Jaipur to Ajmer-Pushkar',
        'location': 'Ajmer',
        'duration': 'Full Day',
        'price': '\₹3,500',
        'rating': '4.8',
        'reviews': '84',
        'image': 'https://images.unsplash.com/photo-1548013146-72479768bada?w=600',
        'highlights': ['Ajmer Sharif Dargah', 'Pushkar Lake', 'Brahma Temple', 'Local market'],
      },
      {
        'title': 'Jaipur to Ranthambore',
        'location': 'Ranthambore',
        'duration': '2 Days',
        'price': '\₹8,999',
        'rating': '4.9',
        'reviews': '112',
        'image': 'https://images.unsplash.com/photo-1549366021-9f761d450615?w=600',
        'highlights': ['Tiger safari', 'Wildlife spotting', 'Resort stay', 'All meals included'],
      },
      {
        'title': 'Jaipur to Jodhpur-Jaisalmer',
        'location': 'Jaisalmer',
        'duration': '3 Days',
        'price': '\₹12,500',
        'rating': '4.8',
        'reviews': '76',
        'image': 'https://images.unsplash.com/photo-1473580044384-7ba9967e16a0?w=600',
        'highlights': ['Desert safari', 'Camel ride', 'Camp stay', 'Mehrangarh Fort'],
      },
    ];

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1200),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Showing ${packages.length} packages',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 20),
            ResponsiveLayout(
              mobile: Column(
                children: packages.map((p) => Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: _packageCard(p),
                )).toList(),
              ),
              tablet: Wrap(
                spacing: 20,
                runSpacing: 20,
                children: packages.map((p) => SizedBox(
                  width: (MediaQuery.of(context).size.width - 88) / 2,
                  child: _packageCard(p),
                )).toList(),
              ),
              desktop: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24,
                  childAspectRatio: 0.65,
                ),
                itemCount: packages.length,
                itemBuilder: (context, index) => _packageCard(packages[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _packageCard(Map<String, dynamic> package) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Stack(
              children: [
                Image.network(
                  package['image']!,
                  height: 180,
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
                          '${package['rating']} (${package['reviews']})',
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
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppConstants.primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...(package['highlights'] as List<String>).map((h) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, size: 12, color: Colors.green[600]),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          h,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          overflow: TextOverflow.ellipsis,
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
}

class _HoverTourCard extends StatefulWidget {
  final Map<String, dynamic> tour;
  const _HoverTourCard({required this.tour});

  @override
  State<_HoverTourCard> createState() => _HoverTourCardState();
}

class _HoverTourCardState extends State<_HoverTourCard> {
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
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: Colors.grey.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_isHovered ? 0.1 : 0.04),
              blurRadius: _isHovered ? 40 : 20,
              offset: Offset(0, _isHovered ? 20 : 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: Column(
            children: [
              Expanded(
                flex: 5,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    AnimatedScale(
                      scale: _isHovered ? 1.05 : 1.0,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOutCubic,
                      child: widget.tour['image'].startsWith('http')
                          ? Image.network(widget.tour['image'], fit: BoxFit.cover)
                          : Image.asset(widget.tour['image'], fit: BoxFit.cover),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.3),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 20,
                      right: 20,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: AppConstants.primaryColor.withOpacity(0.9),
                              border: Border.all(color: Colors.white.withOpacity(0.2)),
                            ),
                            child: Text(
                              widget.tour['price'],
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.tour['title'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          height: 1.2,
                          color: AppConstants.secondaryColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.tour['desc'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          _infoChip(Icons.access_time_filled, widget.tour['duration']),
                          const SizedBox(width: 12),
                          Expanded(child: _infoChip(Icons.location_on, widget.tour['location'])),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  BookingPage(selectedPackage: widget.tour['title']),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isHovered ? AppConstants.primaryColor : AppConstants.secondaryColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'RESERVE NOW',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppConstants.primaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppConstants.primaryColor),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppConstants.secondaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HoverTaxiCard extends StatefulWidget {
  final Map<String, dynamic> cab;
  const _HoverTaxiCard({required this.cab});

  @override
  State<_HoverTaxiCard> createState() => _HoverTaxiCardState();
}

class _HoverTaxiCardState extends State<_HoverTaxiCard> {
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
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: Colors.grey.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_isHovered ? 0.1 : 0.04),
              blurRadius: _isHovered ? 40 : 20,
              offset: Offset(0, _isHovered ? 20 : 10),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: AnimatedScale(
                    scale: _isHovered ? 1.08 : 1.0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    child: Image.asset(widget.cab['image'], fit: BoxFit.contain),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Text(
                    widget.cab['model'],
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: AppConstants.secondaryColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppConstants.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      widget.cab['type'],
                      style: const TextStyle(
                        color: AppConstants.primaryColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _isHovered ? AppConstants.secondaryColor : const Color(0xFFF8F9FA),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
              ),
              child: Column(
                children: [
                  _taxiDetail('Rate', '₹${widget.cab['rate']}'),
                  _taxiDetail('Capacity', '${widget.cab['seats']} Seats'),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookingPage(
                            selectedPackage: '${widget.cab['model']} Rental',
                          ),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'BOOK NOW',
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _taxiDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: _isHovered ? Colors.white70 : Colors.black54,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: _isHovered ? Colors.white : AppConstants.secondaryColor,
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
