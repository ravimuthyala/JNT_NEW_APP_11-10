import 'package:flutter/material.dart';
import 'app_theme.dart'; // for kPink

class ArtistRequestsPage extends StatelessWidget {
  const ArtistRequestsPage({super.key});

  // Mock data – replace with your backend data later
  final List<_ArtistRequest> _requests = const [
    _ArtistRequest(
      id: 'REQ-1001',
      clientName: 'Ravi',
      requestTitle: 'Gold Foil Nude · Almond',
      requestType: 'Custom Nail Design',
      createdLabel: '2h ago',
      neededByLabel: 'Needed by: May 20',
      designStatus: 'In Progress', // 🚫 Shipping not visible yet
      nailShape: 'Almond',
      nailLength: 'Medium',
      leftHandMm: {
        'Thumb': '14.0',
        'Index': '12.5',
        'Middle': '13.0',
        'Ring': '12.8',
        'Pinky': '11.2',
      },
      rightHandMm: {
        'Thumb': '13.8',
        'Index': '12.3',
        'Middle': '13.1',
        'Ring': '12.7',
        'Pinky': '11.0',
      },
      photoUrls: [
        // Use your own images / network URLs or empty list for now
        'https://via.placeholder.com/150x150.png?text=Inspo+1',
        'https://via.placeholder.com/150x150.png?text=Inspo+2',
      ],
      // shipping info exists, BUT will NOT show until designStatus == 'Completed'
      shippingName: 'Ravi M.',
      shippingAddressLine1: '123 Nail St',
      shippingAddressLine2: 'Unit 4B',
      shippingCityStateZip: 'Austin, TX 78701',
    ),
    _ArtistRequest(
      id: 'REQ-1002',
      clientName: 'Anna',
      requestTitle: 'Chrome French · Long',
      requestType: 'Press-on Set',
      createdLabel: 'Yesterday',
      neededByLabel: 'Needed by: May 25',
      designStatus: 'Completed', // ✅ Shipping SHOULD be visible
      nailShape: 'Coffin',
      nailLength: 'Long',
      leftHandMm: {
        'Thumb': '15.0',
        'Index': '13.0',
        'Middle': '13.5',
        'Ring': '13.2',
        'Pinky': '11.8',
      },
      rightHandMm: {
        'Thumb': '14.8',
        'Index': '12.9',
        'Middle': '13.4',
        'Ring': '13.0',
        'Pinky': '11.7',
      },
      photoUrls: [
        'https://via.placeholder.com/150x150.png?text=Inspo+A',
      ],
      shippingName: 'Anna L.',
      shippingAddressLine1: '987 Polish Ave',
      shippingAddressLine2: '',
      shippingCityStateZip: 'Dallas, TX 75201',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        title: const Text(
          'Incoming Requests',
          style: TextStyle(
            color: Color(0xFF333333),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        itemCount: _requests.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final r = _requests[index];

          return InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ArtistRequestDetailPage(request: r),
                ),
              );
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
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
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: kPink.withOpacity(0.15),
                    child: Text(
                      r.clientInitial,
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
                          r.requestTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${r.clientName} • ${r.requestType}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF777777),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          r.neededByLabel,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF555555),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          r.createdLabel,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF9E9E9E),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _statusColor(r.designStatus).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      r.designStatus,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _statusColor(r.designStatus),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  static Color _statusColor(String status) {
    switch (status) {
      case 'In Progress':
        return const Color(0xFF5C6BC0);
      case 'Completed':
        return const Color(0xFF2E7D32);
      case 'Pending':
        return const Color(0xFFF57C00);
      default:
        return const Color(0xFF757575);
    }
  }
}

/// DETAIL PAGE (this is the one you were asking about)
class ArtistRequestDetailPage extends StatelessWidget {
  final _ArtistRequest request;

  const ArtistRequestDetailPage({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    final showShipping = request.designStatus == 'Completed';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        title: Text(
          request.id,
          style: const TextStyle(
            color: Color(0xFF333333),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ----- HEADER: CLIENT + STATUS -----
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: kPink.withOpacity(0.15),
                    child: Text(
                      request.clientInitial,
                      style: const TextStyle(
                        color: kPink,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          request.clientName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          request.requestType,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF777777),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          request.neededByLabel,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF555555),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: ArtistRequestsPage._statusColor(
                              request.designStatus)
                          .withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      request.designStatus,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: ArtistRequestsPage._statusColor(
                            request.designStatus),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ----- PHOTOS SECTION -----
            const Text(
              'Client Photos / Inspiration',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 10),
            if (request.photoUrls.isEmpty)
              Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const Center(
                  child: Text(
                    'No photos uploaded',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF777777),
                    ),
                  ),
                ),
              )
            else
              SizedBox(
                height: 110,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: request.photoUrls.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final url = request.photoUrls[index];
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        url,
                        width: 110,
                        height: 110,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),

            const SizedBox(height: 24),

            // ----- DESIGN DETAILS -----
            const Text(
              'Design Details',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
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
                  // Nail shape & length
                  Row(
                    children: [
                      const Icon(Icons.brush_rounded,
                          size: 18, color: kPink),
                      const SizedBox(width: 6),
                      Text(
                        'Shape: ${request.nailShape} · Length: ${request.nailLength}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Needed by date as part of details too
                  Row(
                    children: [
                      const Icon(Icons.event_outlined,
                          size: 18, color: kPink),
                      const SizedBox(width: 6),
                      Text(
                        request.neededByLabel,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF555555),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  const Divider(),
                  const SizedBox(height: 8),

                  // Nail dimensions table-ish
                  const Text(
                    'Nail Dimensions (mm)',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildDimensionRow('Left Hand', request.leftHandMm),
                  const SizedBox(height: 10),
                  _buildDimensionRow('Right Hand', request.rightHandMm),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ----- SHIPPING INFO (ONLY IF COMPLETED) -----
            if (showShipping) ...[
              const Text(
                'Shipping Information',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
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
                      request.shippingName ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (request.shippingAddressLine1 != null &&
                        request.shippingAddressLine1!.isNotEmpty)
                      Text(
                        request.shippingAddressLine1!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF555555),
                        ),
                      ),
                    if (request.shippingAddressLine2 != null &&
                        request.shippingAddressLine2!.isNotEmpty)
                      Text(
                        request.shippingAddressLine2!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF555555),
                        ),
                      ),
                    if (request.shippingCityStateZip != null &&
                        request.shippingCityStateZip!.isNotEmpty)
                      Text(
                        request.shippingCityStateZip!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF555555),
                        ),
                      ),
                  ],
                ),
              ),
            ] else ...[
              // Little note explaining why shipping is hidden
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Shipping information will be available once this design is marked as Completed and uploaded.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF795548),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  static Widget _buildDimensionRow(
      String label, Map<String, String> values) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: values.entries.map((entry) {
            return Expanded(
              child: Column(
                children: [
                  Text(
                    entry.key,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF5FA),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${entry.value} mm',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF555555),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

/// Simple data model for a request
class _ArtistRequest {
  final String id;
  final String clientName;
  final String requestTitle;
  final String requestType;
  final String createdLabel;
  final String neededByLabel;
  final String designStatus;
  final String nailShape;
  final String nailLength;
  final Map<String, String> leftHandMm;
  final Map<String, String> rightHandMm;
  final List<String> photoUrls;

  // shipping (optional, only shown after completion)
  final String? shippingName;
  final String? shippingAddressLine1;
  final String? shippingAddressLine2;
  final String? shippingCityStateZip;

  const _ArtistRequest({
    required this.id,
    required this.clientName,
    required this.requestTitle,
    required this.requestType,
    required this.createdLabel,
    required this.neededByLabel,
    required this.designStatus,
    required this.nailShape,
    required this.nailLength,
    required this.leftHandMm,
    required this.rightHandMm,
    required this.photoUrls,
    this.shippingName,
    this.shippingAddressLine1,
    this.shippingAddressLine2,
    this.shippingCityStateZip,
  });

  String get clientInitial =>
      clientName.trim().isNotEmpty ? clientName.trim()[0].toUpperCase() : '?';
}