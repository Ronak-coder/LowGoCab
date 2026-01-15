import 'package:flutter/material.dart';
import 'package:lowgo_cab/utils/constants.dart';
import 'package:lowgo_cab/widgets/responsive_layout.dart';
import 'package:lowgo_cab/widgets/custom_header.dart';
import 'package:lowgo_cab/widgets/custom_footer.dart';
import 'booking_page.dart';

class PackagesPage extends StatelessWidget {
  const PackagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> tours = [
      {
        'title': 'One Day Jaipur Sightseeing Tour',
        'price': '₹1,500',
        'desc': 'Detailed tour of Amer Fort, Jal Mahal, Hawa Mahal and more.',
        'image':
            'https://images.unsplash.com/photo-1599661046289-e31897856741?auto=format&fit=crop&q=80&w=800',
        'duration': '8 Hours',
        'location': 'Jaipur City',
      },
      {
        'title': 'Rajasthan Royal Tour Package',
        'price': '₹4,500',
        'desc':
            'Experience the royalty of Rajasthan across multiple heritage cities.',
        'image':
            'https://images.unsplash.com/photo-1524492412937-b28074a5d7da?auto=format&fit=crop&q=80&w=800',
        'duration': '3 Days',
        'location': 'Rajasthan',
      },
      {
        'title': 'Same Day Agra Tour From Jaipur',
        'price': '₹5,500',
        'desc': 'Visit the Taj Mahal and Agra Fort in a one day excursion.',
        'image':
            'https://images.unsplash.com/photo-1564507592333-c60657451ddc?auto=format&fit=crop&q=80&w=800',
        'duration': 'Full Day',
        'location': 'Agra',
      },
      {
        'title': 'Jodhpur Udaipur 4 Days Tour',
        'price': '₹12,000',
        'desc':
            'Explore the blue city and the city of lakes in this premium package.',
        'image':
            'https://images.unsplash.com/photo-1603262110263-fb0112e7cc33?auto=format&fit=crop&q=80&w=800',
        'duration': '4 Days',
        'location': 'Rajasthan',
      },
    ];

    final List<Map<String, dynamic>> cabs = [
      {
        'model': 'Toyota Etios',
        'rate': '11/Km',
        'seats': '4+1',
        'type': 'Sedan',
      },
      {
        'model': 'Toyota Innova',
        'rate': '16/Km',
        'seats': '6+1',
        'type': 'MPV',
      },
      {
        'model': 'Toyota Crysta',
        'rate': '18/Km',
        'seats': '7+1',
        'type': 'Luxury MPV',
      },
      {
        'model': 'Tempo Traveller',
        'rate': '27/Km',
        'seats': '12+1',
        'type': 'Mini Bus',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomHeader(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildModernHero(),
            const SizedBox(height: 80),
            _sectionTitle('Popular Tour Packages'),
            _buildTourGrid(tours, context),
            const SizedBox(height: 100),
            _buildTaxiExperience(cabs, context),
            const CustomFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildModernHero() {
    return Container(
      width: double.infinity,
      height: 400,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            'https://images.unsplash.com/photo-1526772662000-3f88f10405ff?w=1600', // Premium travel road
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
              Colors.black.withOpacity(0.8),
            ],
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'UNFORGETTABLE JOURNEYS',
                style: TextStyle(
                  color: AppConstants.accentColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Our Tour Packages',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 56,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
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
          width: 60,
          height: 4,
          decoration: BoxDecoration(
            color: AppConstants.primaryColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 50),
      ],
    );
  }

  Widget _buildTourGrid(
    List<Map<String, dynamic>> tours,
    BuildContext context,
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
        childAspectRatio: 0.78,
      ),
      itemCount: tours.length,
      itemBuilder: (context, index) {
        final tour = tours[index];
        return _buildTourCard(tour, context);
      },
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
            blurRadius: 20,
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
                  Image.network(tour['image'], fit: BoxFit.cover),
                  Positioned(
                    top: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        tour['price'],
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          color: AppConstants.primaryColor,
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
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tour['title'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      tour['desc'],
                      maxLines: 2,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
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
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
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
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1,
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
    return Row(
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
    );
  }

  Widget _buildTaxiExperience(
    List<Map<String, dynamic>> cabs,
    BuildContext context,
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
        childAspectRatio: 0.72,
      ),
      itemCount: cabs.length,
      itemBuilder: (context, index) {
        final cab = cabs[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey[100]!),
          ),
          child: Column(
            children: [
              const Expanded(
                child: Icon(
                  Icons.directions_car_filled,
                  size: 80,
                  color: AppConstants.primaryColor,
                ),
              ),
              Text(
                cab['model'],
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                cab['type'],
                style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: AppConstants.secondaryColor,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(24),
                  ),
                ),
                child: Column(
                  children: [
                    _taxiDetail('Rate', '₹${cab['rate']}'),
                    _taxiDetail('Capacity', cab['seats']),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
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
                        ),
                        child: const Text('BOOK NOW'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
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
            style: const TextStyle(color: Colors.white60, fontSize: 13),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppConstants.accentColor,
              fontWeight: FontWeight.w900,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
