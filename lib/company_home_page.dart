// lib/company_home_page.dart
import 'package:flutter/material.dart';
import 'company_request_custom_design_page.dart' as company_request;

const Color kPink = Color(0xFFE91E63);

class CompanyHomePage extends StatefulWidget {
  final String companyName;
  const CompanyHomePage({super.key, this.companyName = 'Company'});

  @override
  State<CompanyHomePage> createState() => _CompanyHomePageState();
}

class _CompanyHomePageState extends State<CompanyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        title: Text(
          '${widget.companyName} Dashboard',
          style: const TextStyle(
            color: Color(0xFF333333),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: PopupMenuButton<String>(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onSelected: (v) {},
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'manage', child: Text('Manage Company')),
                PopupMenuItem(value: 'signout', child: Text('Sign Out')),
              ],
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.apartment, color: kPink, size: 18),
                    const SizedBox(width: 8),
                    Text(widget.companyName,
                        style: const TextStyle(color: Color(0xFF333333))),
                    const Icon(Icons.arrow_drop_down, color: Color(0xFF616161)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _whiteCard(
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 22,
                      backgroundColor: Color(0xFFFFE0EC),
                      child: Icon(Icons.apartment, color: kPink),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Welcome back, ${widget.companyName}!',
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF333333))),
                          const SizedBox(height: 4),
                          const Text(
                            'Manage requests, artists, and orders for your company.',
                            style: TextStyle(fontSize: 12, color: Color(0xFF777777)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              const Text('Quick Actions',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF333333))),
              const SizedBox(height: 10),
              Row(
                children: [
                  _QuickActionButton(
                    icon: Icons.add_circle_outline,
                    label: 'New Request',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => company_request.CompanyRequestCustomDesignPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  _QuickActionButton(
                    icon: Icons.people_outline,
                    label: 'Team',
                    onTap: () {},
                  ),
                  const SizedBox(width: 12),
                  _QuickActionButton(
                    icon: Icons.assignment_outlined,
                    label: 'Orders',
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 24),

              const Text('Incoming Client Requests',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF333333))),
              const SizedBox(height: 8),
              _whiteCard(const Text(
                'No new requests right now.',
                style: TextStyle(fontSize: 13, color: Color(0xFF777777)),
              )),
              const SizedBox(height: 24),

              const Text('Team Artists',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF333333))),
              const SizedBox(height: 8),
              _whiteCard(
                Column(
                  children: List.generate(3, (i) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: const Color(0xFFFFE0EC),
                        child: Text(
                          ['A', 'B', 'C'][i],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: kPink),
                        ),
                      ),
                      title: Text('Artist ${i + 1}'),
                      subtitle: const Text('Hand-painted, Custom designs'),
                      trailing: TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Manage',
                          style: TextStyle(color: kPink, fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 24),

              const Text('Company Orders',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF333333))),
              const SizedBox(height: 8),
              _whiteCard(const Text(
                'No active orders yet.',
                style: TextStyle(fontSize: 13, color: Color(0xFF777777)),
              )),
              const SizedBox(height: 24),

              const Text('Promos & Announcements',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF333333))),
              const SizedBox(height: 8),
              _whiteCard(const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Holiday Campaign: Feature Your Artists',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: kPink),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Submit top designs to be featured across JNT.',
                    style: TextStyle(fontSize: 12, color: Color(0xFF777777)),
                  ),
                ],
              )),
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 2) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => company_request.CompanyRequestCustomDesignPage(),
              ),
            );
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: kPink,
        unselectedItemColor: const Color(0xFF9E9E9E),
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.spa_outlined), activeIcon: Icon(Icons.spa), label: 'JNT Salon'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), activeIcon: Icon(Icons.add_circle), label: 'Create'),
          BottomNavigationBarItem(icon: Icon(Icons.groups_outlined), activeIcon: Icon(Icons.groups), label: 'Team'),
          BottomNavigationBarItem(icon: Icon(Icons.apartment_outlined), activeIcon: Icon(Icons.apartment), label: 'Company'),
        ],
      ),
    );
  }

  Widget _whiteCard(Widget child) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))],
      ),
      child: child,
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            children: [
              Icon(icon, size: 20),
              const SizedBox(height: 6),
              Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF333333))),
            ],
          ),
        ),
      ),
    );
  }
}