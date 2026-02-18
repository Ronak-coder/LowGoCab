import 'package:flutter/material.dart';
import 'package:lowgo_cab/utils/constants.dart';
import 'package:lowgo_cab/widgets/responsive_layout.dart';
import 'package:lowgo_cab/widgets/custom_header.dart';
import 'package:lowgo_cab/widgets/custom_footer.dart';
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

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomHeader(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildPremiumHero(isMobile),
            const SizedBox(height: 80),
            _sectionTitle('Popular Tour Packages'),
            _buildTourGrid(tours, context, isMobile),
            const SizedBox(height: 100),
            _buildTaxiExperience(cabs, context, isMobile),
            const CustomFooter(),
          ],
        ),
      ),
    );
  }

  Widget _fadeIn({required Widget child, double delay = 0.0}) {
    final animation = CurvedAnimation(
      parent: _contentController,
      curve: Interval(delay, 1.0, curve: Curves.easeOut),
    );
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.05),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    );
  }

  Widget _buildPremiumHero(bool isMobile) {
    return Container(
      width: double.infinity,
      height: isMobile ? 300 : 450,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            'https://images.unsplash.com/photo-1526772662000-3f88f10405ff?w=1600',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.3),
              Colors.black.withOpacity(0.85),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'UNFORGETTABLE JOURNEYS',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Our Tour Packages',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isMobile ? 44 : 72,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: 80,
          height: 4,
          decoration: BoxDecoration(
            gradient: AppConstants.primaryGradient,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 60),
      ],
    );
  }

  Widget _buildTourGrid(
    List<Map<String, dynamic>> tours,
    BuildContext context,
    bool isMobile,
  ) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1200),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: ResponsiveLayout(
          mobile: _tourList(tours, context, 1),
          tablet: _tourList(tours, context, 2),
          desktop: _tourList(tours, context, 3),
        ),
      ),
    );
  }

  Widget _tourList(
    List<Map<String, dynamic>> tours,
    BuildContext context,
    int crossAxisCount,
  ) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 32,
        mainAxisSpacing: 40,
        childAspectRatio: crossAxisCount == 1 ? 0.85 : 0.72,
      ),
      itemCount: tours.length,
      itemBuilder: (context, index) => _fadeIn(
        child: _buildTourCard(tours[index], context),
        delay: index * 0.1,
      ),
    );
  }

  Widget _buildTourCard(Map<String, dynamic> tour, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 40,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  tour['image'].startsWith('http')
                      ? Image.network(tour['image'], fit: BoxFit.cover)
                      : Image.asset(tour['image'], fit: BoxFit.cover),
                  Positioned(
                    top: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: AppConstants.primaryColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppConstants.primaryColor.withOpacity(0.4),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Text(
                        tour['price'],
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          fontSize: 16,
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
                      tour['title'],
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      tour['desc'],
                      maxLines: 2,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        _infoChip(Icons.access_time_filled, tour['duration']),
                        const SizedBox(width: 12),
                        _infoChip(Icons.location_on, tour['location']),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                BookingPage(selectedPackage: tour['title']),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppConstants.secondaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
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
    );
  }

  Widget _infoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppConstants.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppConstants.primaryColor),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaxiExperience(
    List<Map<String, dynamic>> cabs,
    BuildContext context,
    bool isMobile,
  ) {
    return Container(
      width: double.infinity,
      color: AppConstants.surfaceColor,
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 24),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              _sectionTitle('Luxury Cab Fleet'),
              ResponsiveLayout(
                mobile: _taxiList(cabs, 1),
                tablet: _taxiList(cabs, 2),
                desktop: _taxiList(cabs, 4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _taxiList(List<Map<String, dynamic>> cabs, int crossAxisCount) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
        childAspectRatio: crossAxisCount == 1 ? 0.8 : 0.64,
      ),
      itemCount: cabs.length,
      itemBuilder: (context, index) => _fadeIn(
        child: _buildTaxiCard(cabs[index], context),
        delay: 0.2 + (index * 0.1),
      ),
    );
  }

  Widget _buildTaxiCard(Map<String, dynamic> cab, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey[100]!),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Image.asset(cab['image'], fit: BoxFit.contain),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Text(
                  cab['model'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  cab['type'],
                  style: const TextStyle(
                    color: AppConstants.primaryColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: AppConstants.secondaryColor,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            child: Column(
              children: [
                _taxiDetail('Rate', '₹${cab['rate']}'),
                _taxiDetail('Capacity', '${cab['seats']} Seats'),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingPage(
                          selectedPackage: '${cab['model']} Rental',
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
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
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
