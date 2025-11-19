class ArtistRequest {
  final String id;
  final String clientName;
  final String requestType;
  final String designSummary;
  final DateTime? neededBy;

  final String nailShape;
  final String nailLength;

  // nail dimensions
  final double? leftThumb;
  final double? leftIndex;
  final double? leftMiddle;
  final double? leftRing;
  final double? leftPinky;
  final double? rightThumb;
  final double? rightIndex;
  final double? rightMiddle;
  final double? rightRing;
  final double? rightPinky;

  final String status;
  final DateTime createdAt;

  // shipping info
  final String? shippingName;
  final String? shippingAddressLine1;
  final String? shippingAddressLine2;
  final String? shippingCity;
  final String? shippingState;
  final String? shippingZip;
  final String? shippingCountry;

  ArtistRequest({
    required this.id,
    required this.clientName,
    required this.requestType,
    required this.designSummary,
    required this.neededBy,
    required this.nailShape,
    required this.nailLength,
    required this.leftThumb,
    required this.leftIndex,
    required this.leftMiddle,
    required this.leftRing,
    required this.leftPinky,
    required this.rightThumb,
    required this.rightIndex,
    required this.rightMiddle,
    required this.rightRing,
    required this.rightPinky,
    required this.status,
    required this.createdAt,
    this.shippingName,
    this.shippingAddressLine1,
    this.shippingAddressLine2,
    this.shippingCity,
    this.shippingState,
    this.shippingZip,
    this.shippingCountry,
  });

  factory ArtistRequest.fromMap(Map<String, dynamic> map) {
    DateTime? _parseDate(dynamic v) {
      if (v == null) return null;
      if (v is DateTime) return v;
      return DateTime.tryParse(v.toString());
    }

    double? _toDouble(dynamic v) {
      if (v == null) return null;
      return double.tryParse(v.toString());
    }

    return ArtistRequest(
      id: map['id'] as String,
      clientName: map['client_name'] ?? '',
      requestType: map['request_type'] ?? '',
      designSummary: map['design_summary'] ?? '',
      neededBy: _parseDate(map['needed_by']),

      nailShape: map['nail_shape'] ?? '',
      nailLength: map['nail_length'] ?? '',

      leftThumb: _toDouble(map['left_thumb_mm']),
      leftIndex: _toDouble(map['left_index_mm']),
      leftMiddle: _toDouble(map['left_middle_mm']),
      leftRing: _toDouble(map['left_ring_mm']),
      leftPinky: _toDouble(map['left_pinky_mm']),
      rightThumb: _toDouble(map['right_thumb_mm']),
      rightIndex: _toDouble(map['right_index_mm']),
      rightMiddle: _toDouble(map['right_middle_mm']),
      rightRing: _toDouble(map['right_ring_mm']),
      rightPinky: _toDouble(map['right_pinky_mm']),

      status: map['status'] ?? 'pending',
      createdAt: _parseDate(map['created_at']) ?? DateTime.now(),

      shippingName: map['shipping_name'],
      shippingAddressLine1: map['shipping_address_line1'],
      shippingAddressLine2: map['shipping_address_line2'],
      shippingCity: map['shipping_city'],
      shippingState: map['shipping_state'],
      shippingZip: map['shipping_zip'],
      shippingCountry: map['shipping_country'],
    );
  }
}