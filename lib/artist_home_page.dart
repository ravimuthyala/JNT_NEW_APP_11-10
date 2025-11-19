// lib/artist_home_page.dart
import 'package:flutter/material.dart';
import 'app_theme.dart'; // contains kPink
import 'artist_schedule_page.dart';  
import 'artist_requests_page.dart';

class ArtistHomePage extends StatefulWidget {
  final String artistName;

  const ArtistHomePage({super.key, required this.artistName});

  @override
  State<ArtistHomePage> createState() => _ArtistHomePageState();
}

class _ArtistHomePageState extends State<ArtistHomePage> {
  int _selectedIndex = 0;
  bool _isOnline = true;

  // -------- HEADER (PROFILE & STATUS) --------
  Widget _buildHeader() {
  // Protect against null/empty artistName
      final rawName = (widget.artistName).trim();
      final String firstName =
    rawName.isNotEmpty ? rawName.split(' ').first : 'Artist';
      final String initial =
    firstName.isNotEmpty ? firstName.characters.first.toUpperCase() : 'A';


    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          CircleAvatar(
            radius: 24,
            backgroundColor: kPink.withOpacity(0.15),
            child: Text(
              initial,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: kPink,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Name + today summary + status pill
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi, $firstName 👋',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Today: 3 appointments · 2 new design requests',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF777777),
                  ),
                ),
                const SizedBox(height: 10),

                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isOnline = !_isOnline;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: _isOnline
                          ? kPink.withOpacity(0.1)
                          : const Color(0xFFE0E0E0),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _isOnline
                                ? Colors.green
                                : const Color(0xFF9E9E9E),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _isOnline
                              ? 'Online · accepting new requests'
                              : 'Offline',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _isOnline
                                ? const Color(0xFF2E7D32)
                                : const Color(0xFF616161),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Settings + notifications
          Column(
            children: [
              Row(
                children: [
                  IconButton(
                    tooltip: 'Notifications',
                    icon: const Icon(Icons.notifications_none_rounded),
                    onPressed: () {
                      // TODO: notifications screen
                    },
                  ),
                  IconButton(
                    tooltip: 'Settings',
                    icon: const Icon(Icons.settings_outlined),
                    onPressed: () {
                      // TODO: settings screen
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // -------- 2. TODAY'S OVERVIEW --------
Widget _buildTodayOverviewSection() {
  Widget statCard(String title, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // 👈 let the card size to its content
          children: [
            Icon(icon, size: 18, color: kPink),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF777777),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 👇 no fixed height here
  return Row(
    children: [
      statCard('Today\'s Appointments', '3', Icons.event),
      statCard('New Requests', '2', Icons.inbox_outlined),
      statCard('Pending Approvals', '1', Icons.pending_actions_outlined),
      statCard('Earnings Today', '\$120', Icons.attach_money),
    ],
  );
}


  // -------- 3. INCOMING REQUESTS --------
  Widget _buildIncomingRequestsSection() {
    final requests = [
      {
        'name': 'Ravi',
        'type': 'Custom Nail Design Request',
        'details': 'Almond · Medium · Nude + Gold Foil',
        'time': 'Preferred: Tomorrow · 5:00 PM',
      },
      {
        'name': 'Anna',
        'type': 'Press-on Set Order',
        'details': 'Coffin · Long · Chrome French',
        'time': 'Ship by: May 22',
      },
      {
        'name': 'Sarah',
        'type': 'In-studio Appointment Request',
        'details': 'Squoval · Short · Soft Pink',
        'time': 'Preferred: May 18 · 2:30 PM',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'New Requests',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),
        ...requests.map((r) {
          final name = (r['name'] ?? '').toString().trim();
          final String initial =
    name.isNotEmpty ? name.characters.first.toUpperCase() : '?';
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: kPink.withOpacity(0.15),
                      child: Text(
                        initial!,
                        style: const TextStyle(
                          color: kPink,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            r['name']!,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            r['type']!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF777777),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  r['details']!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF555555),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  r['time']!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF777777),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        // TODO: open full request details
                      },
                      child: const Text('View Details'),
                    ),
                    const Spacer(),
                    OutlinedButton(
                      onPressed: () {
                        // TODO: message client
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: kPink),
                      ),
                      child: const Text('Message'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        // TODO: accept request
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPink,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Accept'),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // -------- 4. TODAY'S SCHEDULE / APPOINTMENTS --------
  Widget _buildScheduleSection() {
    final appointments = [
      {
        'time': '10:00 AM – 11:30 AM',
        'client': 'Ravi',
        'location': 'Home Studio',
        'design': 'Gold Foil Nude · Almond',
        'status': 'Confirmed',
      },
      {
        'time': '1:00 PM – 2:00 PM',
        'client': 'Sarah',
        'location': 'Salon – Downtown',
        'design': 'Short Squoval · Baby Pink',
        'status': 'Awaiting Deposit',
      },
      {
        'time': '4:30 PM – 5:30 PM',
        'client': 'Anna',
        'location': 'Press-on · Ship',
        'design': 'Chrome French · Long',
        'status': 'Completed',
      },
    ];

    Color statusColor(String status) {
      switch (status) {
        case 'Confirmed':
          return const Color(0xFF2E7D32);
        case 'Awaiting Deposit':
          return const Color(0xFFF57C00);
        case 'Completed':
          return const Color(0xFF616161);
        default:
          return const Color(0xFF757575);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Text(
              'Today\'s Schedule',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            Spacer(),
            Text(
              'Today · Week',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF777777),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...appointments.map((a) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  a['time']!,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  a['client']!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  a['location']!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF777777),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  a['design']!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF555555),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor(a['status']!).withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        a['status']!,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: statusColor(a['status']!),
                        ),
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        // TODO: reschedule
                      },
                      child: const Text('Reschedule'),
                    ),
                    const SizedBox(width: 4),
                    OutlinedButton(
                      onPressed: () {
                        // TODO: check-in / start
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: kPink),
                      ),
                      child: const Text('Check-in'),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // -------- 5. ORDERS & PRODUCTION QUEUE --------
  Widget _buildOrdersSection() {
    final orders = [
      {
        'id': 'ORD-1023',
        'client': 'Ravi',
        'design': 'Gold Foil Nude · Almond',
        'status': 'Designing',
        'due': 'Due: May 20',
      },
      {
        'id': 'ORD-1024',
        'client': 'Anna',
        'design': 'Chrome French · Long',
        'status': 'Being Made',
        'due': 'Ship by: May 22',
      },
      {
        'id': 'ORD-1025',
        'client': 'Maya',
        'design': 'Pastel Abstract · Medium',
        'status': 'Ready to Ship',
        'due': 'Ship by: May 19',
      },
    ];

    Color statusColor(String status) {
      switch (status) {
        case 'Designing':
          return const Color(0xFF5C6BC0);
        case 'Being Made':
          return const Color(0xFFF57C00);
        case 'Ready to Ship':
          return const Color(0xFF2E7D32);
        case 'Shipped':
          return const Color(0xFF616161);
        default:
          return const Color(0xFF757575);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Orders in Progress',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),
        ...orders.map((o) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  o['id']!,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${o['client']} • ${o['design']}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF555555),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  o['due']!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF777777),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor(o['status']!).withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        o['status']!,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: statusColor(o['status']!),
                        ),
                      ),
                    ),
                    const Spacer(),
                    OutlinedButton(
                      onPressed: () {
                        // TODO: update status
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: kPink),
                      ),
                      child: const Text('Update Status'),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // -------- 6. EARNINGS & GOALS --------
  Widget _buildEarningsSection() {
    const double progress = 0.72;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Earnings',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: const [
              Expanded(
                child: _EarningTile(label: 'This Week', value: '\$540'),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _EarningTile(label: 'This Month', value: '\$2,150'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Goal: \$3,000 / month',
            style: TextStyle(fontSize: 12, color: Color(0xFF777777)),
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: const Color(0xFFF1F1F1),
              valueColor: const AlwaysStoppedAnimation<Color>(kPink),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${(progress * 100).round()}% reached',
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF777777),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                // TODO: analytics page
              },
              child: const Text('View Full Analytics'),
            ),
          ),
        ],
      ),
    );
  }

  // -------- 7. PORTFOLIO & REVIEWS --------
  Widget _buildPortfolioAndReviewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Portfolio
        Row(
          children: [
            const Text(
              'Your Portfolio',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                // TODO: add new design
              },
              child: const Text('Add New Design'),
            ),
          ],
        ),
        SizedBox(
          height: 150,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _portfolioTile('Pastel Abstract'),
              _portfolioTile('Chrome French'),
              _portfolioTile('Soft Ombré'),
              _portfolioTile('Minimal Nude'),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Reviews
        Row(
          children: [
            const Text(
              'Recent Reviews',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                // TODO: all reviews
              },
              child: const Text('View All'),
            ),
          ],
        ),
        _reviewTile(
          rating: 5.0,
          name: 'Ravi',
          text: 'Loved the shape and color!',
        ),
        const SizedBox(height: 8),
        _reviewTile(
          rating: 4.8,
          name: 'Anna',
          text: 'So gentle and detailed ✨',
        ),
      ],
    );
  }

  Widget _portfolioTile(String label) {
    return Container(
      width: 110,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 70,
            decoration: BoxDecoration(
              color: const Color(0xFFFFE0EC),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: const Icon(
              Icons.brush_rounded,
              color: kPink,
            ),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 4),
          TextButton(
            onPressed: () {
              // TODO: open design
            },
            child: const Text(
              'Post / Edit',
              style: TextStyle(fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  Widget _reviewTile({
    required double rating,
    required String name,
    required String text,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.star, color: Colors.amber, size: 18),
          const SizedBox(width: 4),
          Text(
            rating.toStringAsFixed(1),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF555555),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // -------- 8. TASKS & ALERTS --------
  Widget _buildTasksSection() {
    final tasks = [
      'Upload final photo for Ravi’s order',
      'Confirm appointment with Sarah for May 12',
      'Respond to 2 new chat messages',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tasks & Alerts',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),
        ...tasks.map((t) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.check_box_outline_blank,
                  size: 18,
                  color: Color(0xFF9E9E9E),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    t,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF555555),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // TODO: mark as done
                  },
                  child: const Text('Mark done'),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // -------- HOME TAB CONTENT --------
  Widget _buildHomeTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildTodayOverviewSection(),
            const SizedBox(height: 20),
            _buildIncomingRequestsSection(),
            const SizedBox(height: 20),
            _buildScheduleSection(),
            const SizedBox(height: 20),
            _buildOrdersSection(),
            const SizedBox(height: 20),
            _buildEarningsSection(),
            const SizedBox(height: 20),
            _buildPortfolioAndReviewsSection(),
            const SizedBox(height: 20),
            _buildTasksSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderTab(String title) {
    return Center(
      child: Text(
        '$title\n(Coming soon)',
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 16,
          color: Color(0xFF777777),
        ),
      ),
    );
  }

  // -------- BUILD --------
  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      _buildHomeTab(),
      const ArtistSchedulePage(),
      const ArtistRequestsPage(),
      _buildPlaceholderTab('Orders'),
      _buildPlaceholderTab('Profile'),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        title: Row(
          children: [
            // JNT logo placeholder
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: kPink,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text(
                  'JNT',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Artist Home',
              style: TextStyle(
                color: Color(0xFF333333),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: kPink,
        unselectedItemColor: const Color(0xFF9E9E9E),
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_note_outlined),
            activeIcon: Icon(Icons.event_note),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inbox_outlined),
            activeIcon: Icon(Icons.inbox),
            label: 'Requests',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_mall_outlined),
            activeIcon: Icon(Icons.local_mall),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// Small helper widget for earnings tiles
class _EarningTile extends StatelessWidget {
  final String label;
  final String value;

  const _EarningTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF777777),
            ),
          ),
        ],
      ),
    );
  }
}
