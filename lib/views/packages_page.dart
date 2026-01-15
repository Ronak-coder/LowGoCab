import 'package:flutter/material.dart';
import 'package:lowgo_cab/utils/constants.dart';
import 'package:lowgo_cab/widgets/responsive_layout.dart';
import 'package:lowgo_cab/widgets/custom_header.dart';
import 'booking_page.dart';

class PackagesPage extends StatelessWidget {
  const PackagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> tours = [
      {
        'title': 'One Day Jaipur Sightseeing Tour',
        'price': '160000',
        'desc': 'Detailed tour of Amer Fort, Jal Mahal, Hawa Mahal and more.',
        'image':
            'https://images.unsplash.com/photo-1599661046289-e31897856741?w=800',
        'duration': '8 Hours',
        'location': 'Jaipur City',
      },
      {
        'title': 'Rajasthan Royal Tour Package',
        'price': '₹4500',
        'desc':
            'Experience the royalty of Rajasthan across multiple heritage cities.',
        'image':
            'https://images.unsplash.com/photo-1524492412937-b28074a5d7da?w=800',
        'duration': '3 Days',
        'location': 'Rajasthan',
      },
      {
        'title': 'Same Day Agra Tour From Jaipur',
        'price': '₹5500',
        'desc': 'Visit the Taj Mahal and Agra Fort in a one day excursion.',
        'image':
            'https://images.unsplash.com/photo-1564507592333-c60657451ddc?w=800',
        'duration': 'Full Day',
        'location': 'Agra',
      },
      {
        'title': 'Jodhpur Udaipur 4 Days Tour',
        'price': '₹12000',
        'desc':
            'Explore the blue city and the city of lakes in this premium package.',
        'image':
            'https://images.unsplash.com/photo-1603262110263-fb0112e7cc33?w=800',
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
            _buildPageHero(),
            const SizedBox(height: 60),
            _sectionTitle('OUR BEST TOUR PACKAGES'),
            _buildTourGrid(tours, context),
            const SizedBox(height: 80),
            _buildTaxiSection(cabs, context),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildPageHero() {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            'https://images.unsplash.com/photo-1605141011119-9f7981f18104?w=1600',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        color: Colors.black.withOpacity(0.4),
        child: const Center(
          child: Text(
            'OUR PACKAGES',
            style: TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.w900,
              letterSpacing: 4,
            ),
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
            fontSize: 32,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Container(width: 80, height: 4, color: AppConstants.primaryColor),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildTourGrid(
    List<Map<String, dynamic>> tours,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: ResponsiveLayout(
            mobile: _tourList(tours, 1),
            tablet: _tourList(tours, 2),
            desktop: _tourList(tours, 3),
          ),
        ),
      ),
    );
  }

  Widget _tourList(List<Map<String, dynamic>> tours, int crossAxisCount) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 30,
        mainAxisSpacing: 30,
        childAspectRatio: 0.8,
      ),
      itemCount: tours.length,
      itemBuilder: (context, index) {
        final tour = tours[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey[200]!),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Image.network(
                  tour['image'],
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tour['title'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        tour['desc'],
                        maxLines: 2,
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 14,
                            color: AppConstants.primaryColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            tour['location'],
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: AppConstants.primaryColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            tour['duration'],
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      const Divider(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '₹ ${tour['price']}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: AppConstants.primaryColor,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    BookingPage(selectedPackage: tour['title']),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                            ),
                            child: const Text('VIEW DETAIL'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTaxiSection(
    List<Map<String, dynamic>> cabs,
    BuildContext context,
  ) {
    return Container(
      width: double.infinity,
      color: Colors.grey[50],
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              _sectionTitle('CAB RENTAL SERVICES'),
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
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 0.75,
      ),
      itemCount: cabs.length,
      itemBuilder: (context, index) {
        final cab = cabs[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Icon(
                Icons.directions_car,
                size: 80,
                color: AppConstants.primaryColor,
              ),
              const SizedBox(height: 10),
              Text(
                cab['model'],
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: AppConstants.secondaryColor,
                child: Column(
                  children: [
                    _taxiDetail('Price/Km', '₹ ${cab['rate']}'),
                    _taxiDetail('Seats', cab['seats']),
                    _taxiDetail('AC', 'Available'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.primaryColor,
                      ),
                      child: const Text('BOOK TAXI'),
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
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppConstants.accentColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
