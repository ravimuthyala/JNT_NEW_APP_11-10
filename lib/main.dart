import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // for profile picture upload

void main() {
  runApp(const NailStoreApp());
}

const Color kPink = Color(0xFFE91E63);

enum PaymentType {
  applePay,
  paypal,
  creditCard,
  venmo,
}

class NailStoreApp extends StatelessWidget {
  const NailStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nail Online Store',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: kPink,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      ),
      home: const MainShell(),
      debugShowCheckedModeBanner: false,
    );
  }
}

///================================
/// MAIN SHELL WITH BOTTOM TABS
///================================
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  final List<Widget> _pages = const [
    HomePage(),
    JntSalonPage(),
    CreatePage(),
    ArtistsPage(),
    ProfileEntryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: kPink,
        unselectedItemColor: const Color(0xFF9E9E9E),
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.spa_outlined),
            activeIcon: Icon(Icons.spa),
            label: 'JNT Salon',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            activeIcon: Icon(Icons.add_circle),
            label: 'Create',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.brush_outlined),
            activeIcon: Icon(Icons.brush),
            label: 'Artists',
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

///================================
/// HOME PAGE
///================================
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _showLoginSheet(BuildContext context) {
  showDialog(
    context: context,
    builder: (ctx) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Welcome',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Choose how you want to continue.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF666666),
                ),
              ),
              const SizedBox(height: 20),

              // New Customer text
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'New Customer',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'First time here? Create your profile to shop custom nail designs.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF777777),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx); // close dialog
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ProfileEntryPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPink,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Continue as New Customer',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Existing Customer text
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Existing Customer',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Already have an account? Log in to see your orders and favorites.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF777777),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Existing customer login not implemented yet.',
                        ),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: const BorderSide(color: kPink),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Continue as Existing Customer',
                    style: TextStyle(
                      color: kPink,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

  Widget _heroSection(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        children: [
          // Background image: hand with paintbrush & drop onto nail
          SizedBox(
            height: 230,
            width: double.infinity,
            child: Image.asset(
              'assets/images/hero_nails.png', // make sure this exists
              fit: BoxFit.cover,
            ),
          ),
          // Gradient overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.15),
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ),
          // Text and buttons
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  const Text(
                    'Art in Every Stroke',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Hand-painted nail designs from artists around the world, made just for you.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFFEFEFEF),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: navigate to designs / create tab
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: kPink,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                          child: const Text(
                            'Browse Designs',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        onPressed: () {
                          // TODO: navigate to artist signup flow
                        },
                        icon: const Icon(
                          Icons.brush,
                          size: 18,
                        ),
                        label: const Text(
                          'Become an Artist',
                          style: TextStyle(fontSize: 12),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.16),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 9,
                            horizontal: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999),
                            side: BorderSide(
                              color: Colors.white.withOpacity(0.4),
                            ),
                          ),
                        ),
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
  }

  Widget _sectionTitle(String title, {String? subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF333333),
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF777777),
            ),
          ),
        ],
      ],
    );
  }

  Widget _trendingCard(String title, String tag) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(18),
                ),
                gradient: LinearGradient(
                  colors: [Color(0xFFFFE0EC), Color(0xFFFFF5FA)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.image,
                  color: kPink,
                  size: 32,
                ),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 4),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, bottom: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0F7),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  tag,
                  style: const TextStyle(
                    fontSize: 10,
                    color: kPink,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _howItWorksStep(int number, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: const Color(0xFFFFE0EC),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Center(
            child: Text(
              number.toString(),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: kPink,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF666666),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nail Online Store',
          style: TextStyle(
            color: Color(0xFF333333),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TextButton(
              onPressed: () => _showLoginSheet(context),
              child: const Text(
                'Login',
                style: TextStyle(
                  color: kPink,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search nail designs or artists',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 0,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Hero
              _heroSection(context),
              const SizedBox(height: 24),

              // Trending
              _sectionTitle(
                'Trending Now',
                subtitle: 'Popular hand-painted sets loved by the community',
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 160,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final titles = [
                      'Pastel Brush Strokes',
                      'Chrome Tips',
                      'Minimal French',
                      'Galaxy Drip',
                      'Blush Ombre',
                    ];
                    final tags = [
                      'Hand-painted',
                      'Metallic',
                      'Classic',
                      'Bold',
                      'Soft glam',
                    ];
                    final i = index % titles.length;
                    return _trendingCard(titles[i], tags[i]);
                  },
                ),
              ),
              const SizedBox(height: 24),

              // How it works
              _sectionTitle(
                'How It Works',
                subtitle:
                    'Order custom press-on sets that fit your nails perfectly.',
              ),
              const SizedBox(height: 12),
              _howItWorksStep(
                1,
                'Tell us your style',
                'Share your inspo pics, colors and nail shape. Our artists turn your vision into a design.',
              ),
              const SizedBox(height: 10),
              _howItWorksStep(
                2,
                'Get matched to artists',
                'Browse proposals from multiple artists and choose the one that fits your vibe and budget.',
              ),
              const SizedBox(height: 10),
              _howItWorksStep(
                3,
                'Receive & apply',
                'Your custom set is shipped to your door with a sizing kit and easy application instructions.',
              ),
              const SizedBox(height: 28),

              // CTA strip
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.spa, color: kPink),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Ready to find your next favorite set?',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // TODO: navigate to create / designs tab
                      },
                      child: const Text(
                        'Start now',
                        style: TextStyle(
                          color: kPink,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

///================================
/// OTHER TABS (simple placeholders)
///================================

class JntSalonPage extends StatelessWidget {
  const JntSalonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimpleScaffoldPage(
      title: 'JNT Salon',
      text:
          'This is the JNT Salon page.\nYou can list salon info, services, and bookings here.',
    );
  }
}

class CreatePage extends StatelessWidget {
  const CreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimpleScaffoldPage(
      title: 'Create',
      text:
          'This is the Create page.\nUse this area for custom nail design requests.',
    );
  }
}

class ArtistsPage extends StatelessWidget {
  const ArtistsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimpleScaffoldPage(
      title: 'Artists',
      text:
          'This is the Artists page.\nShow artist lists, portfolios, and profiles here.',
    );
  }
}

class SimpleScaffoldPage extends StatelessWidget {
  final String title;
  final String text;
  const SimpleScaffoldPage({
    super.key,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
      ),
      body: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 15),
        ),
      ),
    );
  }
}

///================================
/// PROFILE ENTRY PAGE (Client / Artist / Company)
///================================
class ProfileEntryPage extends StatefulWidget {
  const ProfileEntryPage({super.key});

  @override
  State<ProfileEntryPage> createState() => _ProfileEntryPageState();
}

class _ProfileEntryPageState extends State<ProfileEntryPage> {
  bool _clientSelected = false;
  bool _artistSelected = false;
  bool _companySelected = false; // can be selected too, but not required as multi

  void _toggleClient() {
    setState(() {
      // If Company was selected, turn it off
      if (_companySelected) {
        _companySelected = false;
      }
      _clientSelected = !_clientSelected;
    });
  }

  void _toggleArtist() {
    setState(() {
      // If Company was selected, turn it off
      if (_companySelected) {
        _companySelected = false;
      }
      _artistSelected = !_artistSelected;
    });
  }

  void _toggleCompany() {
    setState(() {
      if (_companySelected) {
        // Tapping again just unselects Company
        _companySelected = false;
      } else {
        // Company is exclusive → turn off Client/Artist
        _companySelected = true;
        _clientSelected = false;
        _artistSelected = false;
      }
    });
  }

  Widget _roleCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFFF0F7) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? kPink : const Color(0xFFE0E0E0),
            width: selected ? 2 : 1,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: selected ? kPink : const Color(0xFFFFE0EC),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: selected ? Colors.white : kPink,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF666666),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              selected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: selected ? kPink : const Color(0xFFBDBDBD),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool anySelected = _clientSelected || _artistSelected || _companySelected;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Account Type',
          style: TextStyle(
            color: Color(0xFF333333),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tell us how you want to use JNT Nails.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'You can select both Client and Artist if you buy and sell nail designs. Company can also be selected if you purchase on behalf of a business.',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF777777),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),

              // Client + Artist row (multi-select)
              Row(
                children: [
                  Expanded(
                    child: _roleCard(
                      title: 'Client',
                      subtitle: 'I want to purchase nail designs for myself or others.',
                      icon: Icons.shopping_bag_outlined,
                      selected: _clientSelected,
                      onTap: _toggleClient,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _roleCard(
                      title: 'Artist',
                      subtitle: 'I want to sell my nail designs and take custom requests.',
                      icon: Icons.brush_outlined,
                      selected: _artistSelected,
                      onTap: _toggleArtist,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Company (full width)
              _roleCard(
                title: 'Company',
                subtitle: 'I want to purchase nail designs on behalf of a salon or brand.',
                icon: Icons.apartment_outlined,
                selected: _companySelected,
                onTap: _toggleCompany,
              ),

              const SizedBox(height: 24),

              // Continue button (future: route to specific onboarding based on selection)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: anySelected
                    ? () {
                        if (_clientSelected) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const ClientProfilePage(),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Artist/Company onboarding not implemented yet. Please select Client to continue.',
                              ),
                            ),
                          );
                        }
                      }
                    : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPink,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    disabledBackgroundColor: Colors.grey.shade300,
                    disabledForegroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
///================================
/// CLIENT PROFILE PAGE
///================================
class ClientProfilePage extends StatefulWidget {
  const ClientProfilePage({super.key});

  @override
  State<ClientProfilePage> createState() => _ClientProfilePageState();
}

class _ClientProfilePageState extends State<ClientProfilePage> {
  final _formKey = GlobalKey<FormState>();

  // Basic info controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _instagramController = TextEditingController();
  final TextEditingController _tiktokController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  // Address controllers
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();

  String? _selectedState;
  String? _selectedCountry;

  // Nail dimensions (simple controllers)
  final Map<String, TextEditingController> _leftHand = {
    'Thumb': TextEditingController(),
    'Index': TextEditingController(),
    'Middle': TextEditingController(),
    'Ring': TextEditingController(),
    'Pinky': TextEditingController(),
  };

  final Map<String, TextEditingController> _rightHand = {
    'Thumb': TextEditingController(),
    'Index': TextEditingController(),
    'Middle': TextEditingController(),
    'Ring': TextEditingController(),
    'Pinky': TextEditingController(),
  };

  // Profile picture
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickProfilePicture() async {
    final XFile? picked =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) {
      setState(() {
        _profileImage = File(picked.path);
      });
    }
  }
  String? _selectedNailShape;

  final List<String> _nailShapes = const [
    'Square',
    'Round',
    'Oval',
    'Almond',
    'Stiletto',
    'Coffin',
    'Ballerina',
    'Squoval',
    'Mountain Peak',
    'Lipstick',
    'Flare',
    'Edge',
    'Arrow',
    'Pipe',
    'Pointed',
    'Hexagon',
  ];
    String _paymentTypeLabel(PaymentType type) {
    switch (type) {
      case PaymentType.applePay:
        return 'Apple Pay';
      case PaymentType.paypal:
        return 'PayPal';
      case PaymentType.creditCard:
        return 'Credit Card';
      case PaymentType.venmo:
        return 'Venmo';
    }
  }
  void _savePaymentMethod() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      // Let form validation messages show for required fields
      return;
    }

    String description;

    switch (_selectedPaymentType) {
      case PaymentType.creditCard:
        final raw =
            _cardNumberController.text.replaceAll(' ', '').replaceAll('-', '');
        final last4 = raw.length >= 4 ? raw.substring(raw.length - 4) : raw;
        description =
            'Credit Card •••• $last4 (${_cardNameController.text.trim()})';
        break;

      case PaymentType.applePay:
        description =
            'Apple Pay (${_paymentAccountController.text.trim()})';
        break;

      case PaymentType.paypal:
        description =
            'PayPal (${_paymentAccountController.text.trim()})';
        break;

      case PaymentType.venmo:
        description =
            'Venmo (${_paymentAccountController.text.trim()})';
        break;
    }

    setState(() {
      _savedPaymentMethods.add(description);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment method saved: $description')),
    );

    // Clear only payment-related fields
    _cardNameController.clear();
    _cardNumberController.clear();
    _cardExpiryController.clear();
    _cardCvvController.clear();
    _paymentAccountController.clear();
  }

  String? _selectedNailLength;

  final List<Map<String, String>> _nailLengths = const [
    {
      'name': 'Short',
      'subtitle': 'Just Past Fingertip',
    },
    {
      'name': 'Medium',
      'subtitle': 'Classic Length',
    },
    {
      'name': 'Long',
      'subtitle': 'Extended Length',
    },
    {
      'name': 'Extra Long',
      'subtitle': 'Statement Length',
    },
    {
      'name': 'XL Long',
      'subtitle': 'Maximum Length',
    },
  ];

  final List<String> _usStates = const [
    'Alabama',
    'Alaska',
    'Arizona',
    'Arkansas',
    'California',
    'Colorado',
    'Connecticut',
    'Delaware',
    'Florida',
    'Georgia',
    'Hawaii',
    'Idaho',
    'Illinois',
    'Indiana',
    'Iowa',
    'Kansas',
    'Kentucky',
    'Louisiana',
    'Maine',
    'Maryland',
    'Massachusetts',
    'Michigan',
    'Minnesota',
    'Mississippi',
    'Missouri',
    'Montana',
    'Nebraska',
    'Nevada',
    'New Hampshire',
    'New Jersey',
    'New Mexico',
    'New York',
    'North Carolina',
    'North Dakota',
    'Ohio',
    'Oklahoma',
    'Oregon',
    'Pennsylvania',
    'Rhode Island',
    'South Carolina',
    'South Dakota',
    'Tennessee',
    'Texas',
    'Utah',
    'Vermont',
    'Virginia',
    'Washington',
    'West Virginia',
    'Wisconsin',
    'Wyoming',
  ];
  // Payment method state
  PaymentType _selectedPaymentType = PaymentType.creditCard;

  // Credit card fields
  final TextEditingController _cardNameController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardExpiryController = TextEditingController();
  final TextEditingController _cardCvvController = TextEditingController();

  // For Apple Pay / PayPal / Venmo (email / username)
  final TextEditingController _paymentAccountController =
      TextEditingController();

  // Simple in-page list of saved methods
  final List<String> _savedPaymentMethods = [];

  // Sample country list – you can expand this to full list
  final List<String> _countries = const [
    'United States',
    'Canada',
    'United Kingdom',
    'Australia',
    'India',
    'Germany',
    'France',
    'Italy',
    'Spain',
    'Brazil',
    'Mexico',
    'Japan',
    'China',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _instagramController.dispose();
    _tiktokController.dispose();
    _bioController.dispose();

    _cardNameController.dispose();
    _cardNumberController.dispose();
    _cardExpiryController.dispose();
    _cardCvvController.dispose();
    _paymentAccountController.dispose();

    _streetController.dispose();
    _cityController.dispose();
    _zipController.dispose();

    for (final c in _leftHand.values) {
      c.dispose();
    }
    for (final c in _rightHand.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _submitProfile() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedState == null || _selectedCountry == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select State and Country.'),
          ),
        );
        return;
      }

      // Simulate saving profile & staying on page
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Client profile created (simulated).'),
        ),
      );
    }
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF333333),
        ),
      ),
    );
  }

  Widget _buildBasicInformationSection() {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFFFFF5FA),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Basic Information',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Fill in your details to create your client account',
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF777777),
          ),
        ),
        const SizedBox(height: 16),

        // Profile picture block like the screenshot
        Center(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  // Circular placeholder (dotted-like border)
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 2,
                      ),
                    ),
                    child: ClipOval(
                      child: _profileImage != null
                          ? Image.file(
                              _profileImage!,
                              fit: BoxFit.cover,
                            )
                          : Icon(
                              Icons.photo_camera_outlined,
                              size: 40,
                              color: Colors.grey.shade400,
                            ),
                    ),
                  ),
                  // Pink upload FAB
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: InkWell(
                      onTap: _pickProfilePicture,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: kPink,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.upload_outlined,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Upload Profile Picture',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF555555),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        _buildTextField(
          label: 'Name',
          controller: _nameController,
          requiredField: true,
        ),
        const SizedBox(height: 12),
        _buildTextField(
          label: 'Email',
          controller: _emailController,
          requiredField: true,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 12),
        _buildTextField(
          label: 'Instagram',
          controller: _instagramController,
        ),
        const SizedBox(height: 12),
        _buildTextField(
          label: 'TikTok',
          controller: _tiktokController,
        ),
        const SizedBox(height: 12),
        _buildTextField(
          label: 'Bio',
          controller: _bioController,
          maxLines: 4,
        ),
      ],
    ),
  );
}

    Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool requiredField = false,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? hintText,
    int? maxLength,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
            children: requiredField
                ? const [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: kPink),
                    ),
                  ]
                : [],
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          maxLength: maxLength,
          validator: requiredField
              ? (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'This field is required';
                  }
                  return null;
                }
              : null,
          decoration: InputDecoration(
            counterText: '',
            hintText: hintText,
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: kPink, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Address Information'),
        const SizedBox(height: 4),
        _buildTextField(
          label: 'Street Address',
          controller: _streetController,
          requiredField: true,
        ),
        const SizedBox(height: 12),
        _buildTextField(
          label: 'City',
          controller: _cityController,
          requiredField: true,
        ),
        const SizedBox(height: 12),
        _buildDropdown<String>(
          label: 'State',
          requiredField: true,
          value: _selectedState,
          items: _usStates,
          onChanged: (value) {
            setState(() {
              _selectedState = value;
            });
          },
        ),
        const SizedBox(height: 12),
        _buildTextField(
          label: 'Zip Code',
          controller: _zipController,
          requiredField: true,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 12),
        _buildDropdown<String>(
          label: 'Country',
          requiredField: true,
          value: _selectedCountry,
          items: _countries,
          onChanged: (value) {
            setState(() {
              _selectedCountry = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required bool requiredField,
    required T? value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
            children: requiredField
                ? const [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: kPink),
                    ),
                  ]
                : [],
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<T>(
          initialValue: value,
          items: items
              .map(
                (e) => DropdownMenuItem<T>(
                  value: e,
                  child: Text(e.toString()),
                ),
              )
              .toList(),
          onChanged: onChanged,
          validator: requiredField
              ? (val) {
                  if (val == null) {
                    return 'This field is required';
                  }
                  return null;
                }
              : null,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: kPink, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNailDimensionSection() {
    Widget nailRow(Map<String, TextEditingController> hand) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: hand.entries.map((entry) {
          final finger = entry.key;
          final controller = entry.value;
          return Expanded(
            child: Column(
              children: [
                Text(
                  finger,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  width: 36,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE0E8),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: kPink, width: 1.5),
                  ),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  width: 60,
                  child: TextField(
                    controller: controller,
                    textAlign: TextAlign.center,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      hintText: '0.0',
                      hintStyle: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade400,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'mm',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF666666),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      );
    }

    return Column(
      children: [
        _sectionTitle('Nail Dimension (in mm)'),
        const SizedBox(height: 8),
        const Center(
          child: Text(
            'Left Hand',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
          ),
        ),
        const SizedBox(height: 12),
        nailRow(_leftHand),
        const SizedBox(height: 20),
        const Center(
          child: Text(
            'Right Hand',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
          ),
        ),
        const SizedBox(height: 12),
        nailRow(_rightHand),
        const SizedBox(height: 20),
        Divider(
          color: Colors.grey.shade300,
          thickness: 1,
        ),
      ],
    );
  }

  Widget _buildSizeReferenceSection() {
    Widget sizeCard(String label, String range) {
      return Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                range,
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

    return Column(
      children: [
        const Text(
          'Size Reference',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            sizeCard('Small', '8–12mm'),
            const SizedBox(width: 10),
            sizeCard('Medium', '12–16mm'),
            const SizedBox(width: 10),
            sizeCard('Large', '16–20mm'),
          ],
        ),
      ],
    );
  }

  Widget _buildMeasurementTipsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9FB),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Row(
            children: [
              Icon(
                Icons.tips_and_updates_outlined,
                color: kPink,
                size: 22,
              ),
              SizedBox(width: 8),
              Text(
                'Measurement Tips',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            '• Measure at the widest part of your nail bed',
            style: TextStyle(fontSize: 13, color: Color(0xFF666666)),
          ),
          SizedBox(height: 6),
          Text(
            '• Use the tape method for most accurate results',
            style: TextStyle(fontSize: 13, color: Color(0xFF666666)),
          ),
          SizedBox(height: 6),
          Text(
            '• Round the nearest 0.5mm',
            style: TextStyle(fontSize: 13, color: Color(0xFF666666)),
          ),
          SizedBox(height: 6),
          Text(
            '• Each figure is different - measure all 10!',
            style: TextStyle(fontSize: 13, color: Color(0xFF666666)),
          ),
          SizedBox(height: 6),
          Text(
            '• Left and right hands often have different sizes',
            style: TextStyle(fontSize: 13, color: Color(0xFF666666)),
          ),
        ],
      ),
    );
  }
  Widget _buildNailShapeCard(String shapeName) {
    final bool isSelected = _selectedNailShape == shapeName;

    // We visually distinguish shapes by slightly varying the border radius/size
    BorderRadius radius;
    switch (shapeName) {
      case 'Square':
        radius = BorderRadius.circular(4);
        break;
      case 'Round':
        radius = BorderRadius.circular(30);
        break;
      case 'Oval':
        radius = BorderRadius.circular(40);
        break;
      case 'Almond':
        radius = BorderRadius.circular(32);
        break;
      case 'Stiletto':
      case 'Arrow':
      case 'Pointed':
        radius = const BorderRadius.vertical(
          top: Radius.circular(40),
          bottom: Radius.circular(8),
        );
        break;
      case 'Coffin':
      case 'Ballerina':
        radius = BorderRadius.circular(12);
        break;
      case 'Squoval':
        radius = BorderRadius.circular(20);
        break;
      case 'Mountain Peak':
        radius = const BorderRadius.vertical(
          top: Radius.circular(38),
          bottom: Radius.circular(10),
        );
        break;
      case 'Lipstick':
        radius = BorderRadius.circular(18);
        break;
      case 'Flare':
        radius = BorderRadius.circular(24);
        break;
      case 'Edge':
      case 'Pipe':
        radius = BorderRadius.circular(16);
        break;
      case 'Hexagon':
        radius = BorderRadius.circular(10);
        break;
      default:
        radius = BorderRadius.circular(20);
    }

    return InkWell(
      onTap: () {
        setState(() {
          _selectedNailShape = shapeName;
        });
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 90,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? kPink : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Container(
              height: 60,
              width: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFFFE0EC),
                borderRadius: radius,
                border: Border.all(color: kPink, width: 1.2),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              shapeName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
              ),
            ),
          ],
        ),
      ),
    );
  }
    Widget _buildNailShapeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose Your Nail Shape',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Select from 16 available shapes',
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF777777),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _nailShapes.length,
            itemBuilder: (context, index) {
              final shapeName = _nailShapes[index];
              return _buildNailShapeCard(shapeName);
            },
          ),
        ),
      ],
    );
  }

    Widget _buildNailLengthSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose Your Nail Length',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Pick how long you like your nails to be',
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF777777),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _nailLengths.length,
            itemBuilder: (context, index) {
              final item = _nailLengths[index];
              return _buildNailLengthCard(
                item['name']!,
                item['subtitle']!,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNailLengthCard(String name, String subtitle) {
    final bool isSelected = _selectedNailLength == name;

    // A simple visual: bigger height when length is longer
    double height;
    switch (name) {
      case 'Short':
        height = 40;
        break;
      case 'Medium':
        height = 55;
        break;
      case 'Long':
        height = 70;
        break;
      case 'Extra Long':
        height = 85;
        break;
      case 'XL Long':
        height = 100;
        break;
      default:
        height = 55;
    }

    return InkWell(
      onTap: () {
        setState(() {
          _selectedNailLength = name;
        });
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 130,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? kPink : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Length visual
            Container(
              width: 32,
              height: height,
              decoration: BoxDecoration(
                color: const Color(0xFFFFE0EC),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: kPink, width: 1.2),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              name,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF777777),
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
Widget _buildSizingKitSectionWithContext(BuildContext context) {
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
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            'assets/images/nail_sizing_kit.png',
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Nail Sizing Kit',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Get a reusable sizing kit to measure each nail accurately at home.',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF777777),
                  height: 1.4,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '\$3.00',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: kPink,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {
            // mock cart action
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Added Nail Sizing Kit to cart (simulated).'),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: kPink,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Add to Cart',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}

  Widget _buildFieldsForSelectedPaymentType() {
    switch (_selectedPaymentType) {
      case PaymentType.creditCard:
        return Column(
          children: [
            _buildTextField(
              label: 'Name on Card',
              controller: _cardNameController,
              requiredField: true,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              label: 'Card Number',
              controller: _cardNumberController,
              requiredField: true,
              keyboardType: TextInputType.number,
              hintText: '•••• •••• •••• ••••',
              maxLength: 19,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    label: 'Expiry (MM/YY)',
                    controller: _cardExpiryController,
                    requiredField: true,
                    keyboardType: TextInputType.datetime,
                    hintText: '08/27',
                    maxLength: 5,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    label: 'CVV',
                    controller: _cardCvvController,
                    requiredField: true,
                    keyboardType: TextInputType.number,
                    hintText: '123',
                    maxLength: 4,
                  ),
                ),
              ],
            ),
          ],
        );

      case PaymentType.applePay:
        return _buildTextField(
          label: 'Apple ID / Email',
          controller: _paymentAccountController,
          requiredField: true,
          keyboardType: TextInputType.emailAddress,
          hintText: 'your-apple-id@example.com',
        );

      case PaymentType.paypal:
        return _buildTextField(
          label: 'PayPal Email',
          controller: _paymentAccountController,
          requiredField: true,
          keyboardType: TextInputType.emailAddress,
          hintText: 'your-paypal-email@example.com',
        );

      case PaymentType.venmo:
        return _buildTextField(
          label: 'Venmo Username or Phone',
          controller: _paymentAccountController,
          requiredField: true,
          hintText: '@username or phone number',
        );
    }
  }
  Widget _buildSavedPaymentMethodsList() {
    if (_savedPaymentMethods.isEmpty) {
      return const Text(
        'No payment methods saved yet.',
        style: TextStyle(
          fontSize: 13,
          color: Color(0xFF777777),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _savedPaymentMethods.length,
      separatorBuilder: (_, __) => const Divider(height: 16),
      itemBuilder: (context, index) {
        final method = _savedPaymentMethods[index];
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.payment, color: kPink),
          title: Text(
            method,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              setState(() {
                _savedPaymentMethods.removeAt(index);
              });
            },
          ),
        );
      },
    );
  }
  Widget _buildPaymentMethodSection() {
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
            'Payment Methods',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Save a preferred payment method to use for future orders.',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF777777),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),

          // Payment type chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: PaymentType.values.map((type) {
              final isSelected = _selectedPaymentType == type;
              return ChoiceChip(
                label: Text(_paymentTypeLabel(type)),
                selected: isSelected,
                selectedColor: kPink.withOpacity(0.15),
                labelStyle: TextStyle(
                  color: isSelected ? kPink : const Color(0xFF333333),
                  fontWeight:
                      isSelected ? FontWeight.bold : FontWeight.w500,
                ),
                onSelected: (_) {
                  setState(() {
                    _selectedPaymentType = type;
                  });
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          _buildFieldsForSelectedPaymentType(),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _savePaymentMethod,
              style: ElevatedButton.styleFrom(
                backgroundColor: kPink,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Save Payment Method',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),
          const Text(
            'Saved Payment Methods',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 8),

          _buildSavedPaymentMethodsList(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Client Profile',
          style: TextStyle(
            color: Color(0xFF333333),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBasicInformationSection(),
                const SizedBox(height: 20),
                _buildAddressSection(),
                const SizedBox(height: 20),
                _buildNailDimensionSection(),
                const SizedBox(height: 20),
                _buildSizeReferenceSection(),
                const SizedBox(height: 20),
                _buildMeasurementTipsSection(),
                const SizedBox(height: 20),
                _buildNailShapeSection(),
                const SizedBox(height: 20),
                _buildNailLengthSection(),
                const SizedBox(height: 24),
                    // 👇 New: Nail Sizing Kit product card
    Builder(
      builder: (context) {
        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          child: _buildSizingKitSectionWithContext(context),
        );
      },
    ),
                const SizedBox(height: 24),
    _buildPaymentMethodSection(),
    const SizedBox(height: 20),
// 👇 New: Manage Payment Methods button

const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPink,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Create Account',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}