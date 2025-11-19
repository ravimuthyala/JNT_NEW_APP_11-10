import 'package:flutter/material.dart';
import 'app_theme.dart';

class ArtistsPage extends StatefulWidget {
  const ArtistsPage({super.key});

  @override
  State<ArtistsPage> createState() => _ArtistsPageState();
}

class _ArtistsPageState extends State<ArtistsPage> {
  // Temporary in-memory artist list – later you can replace with DB data.
  final List<_ArtistData> _artists = const [
    _ArtistData(
      id: '1',
      name: 'Sarah Johnson',
      studioName: 'Glamour Nails Studio',
      rating: 4.8,
      isRegisteredTech: true,
      experienceLabel: 'Professional',
      about:
          'Specializing in intricate nail art designs with 8+ years of experience.',
    ),
    _ArtistData(
      id: '2',
      name: 'Mia Chen',
      studioName: 'City Lights Nails',
      rating: 4.6,
      isRegisteredTech: true,
      experienceLabel: 'Advanced',
      about: 'Loves chrome, cat-eye and sculpted gel looks.',
    ),
    _ArtistData(
      id: '3',
      name: 'Lena Rivera',
      studioName: 'Blush & Brush',
      rating: 4.5,
      isRegisteredTech: false,
      experienceLabel: 'Intermediate',
      about: 'Soft glam, pastel palettes and minimalist designs.',
    ),
  ];

  String? _selectedArtistId;

  @override
  void initState() {
    super.initState();
    if (_artists.isNotEmpty) {
      _selectedArtistId = _artists.first.id;
    }
  }

  _ArtistData? get _selectedArtist {
    if (_selectedArtistId == null) return null;
    try {
      return _artists.firstWhere((a) => a.id == _selectedArtistId);
    } catch (_) {
      return _artists.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final artist = _selectedArtist;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF333333)),
          onPressed: () {
            // Go back to the root (Home/MainShell)
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/',
              (route) => false,
            );
          },
        ),
        title: const Text(
          'Artists',
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
              // --- Select an Artist section ---
              const Text(
                'Select an Artist',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Browse our talented artists and view their profiles.',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF777777),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _selectedArtistId,
                items: _artists
                    .map(
                      (a) => DropdownMenuItem<String>(
                        value: a.id,
                        child: Text(a.name),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedArtistId = value;
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
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
              const SizedBox(height: 20),

              if (artist != null) _buildArtistProfileCard(artist),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildArtistProfileCard(_ArtistData artist) {
    return Container(
      width: double.infinity,
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row: avatar + name + rating
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 26,
                backgroundColor: Color(0xFFE0E0E0),
                child: Icon(Icons.person, color: Color(0xFF757575)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      artist.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star,
                            size: 16, color: Color(0xFFFFC107)),
                        const SizedBox(width: 4),
                        Text(
                          artist.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      artist.studioName,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Registered badge
          if (artist.isRegisteredTech)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F9ED),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.workspace_premium,
                      size: 16, color: Color(0xFF27AE60)),
                  SizedBox(width: 6),
                  Text(
                    'Registered Nail Technician',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF27AE60),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 16),
          const Divider(height: 1),

          // Level of experience
          const SizedBox(height: 14),
          Row(
            children: [
              Icon(Icons.star_border, color: kPink, size: 20),
              const SizedBox(width: 6),
              const Text(
                'Level of Experience',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            height: 6,
            width: double.infinity,
            decoration: BoxDecoration(
              color: kPink,
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            artist.experienceLabel,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: kPink,
            ),
          ),

          // About
          const SizedBox(height: 18),
          const Text(
            'About',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            artist.about,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF666666),
              height: 1.4,
            ),
          ),

          // Previous projects
          const SizedBox(height: 18),
          const Text(
            'Previous Projects',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 90,
            child: Row(
              children: [
                _buildProjectPlaceholder(),
                const SizedBox(width: 8),
                _buildProjectPlaceholder(),
                const SizedBox(width: 8),
                _buildProjectPlaceholder(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectPlaceholder() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            colors: [Color(0xFFFFE0EC), Color(0xFFFFF5FA)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Center(
          child: Icon(
            Icons.image,
            size: 32,
            color: kPink,
          ),
        ),
      ),
    );
  }
}

class _ArtistData {
  final String id;
  final String name;
  final String studioName;
  final double rating;
  final bool isRegisteredTech;
  final String experienceLabel;
  final String about;

  const _ArtistData({
    required this.id,
    required this.name,
    required this.studioName,
    required this.rating,
    required this.isRegisteredTech,
    required this.experienceLabel,
    required this.about,
  });
}