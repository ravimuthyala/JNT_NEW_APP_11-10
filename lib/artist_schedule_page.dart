import 'package:flutter/material.dart';
import 'app_theme.dart'; // kPink

enum _ScheduleView { today, week, month }

class ArtistSchedulePage extends StatefulWidget {
  const ArtistSchedulePage({super.key});

  @override
  State<ArtistSchedulePage> createState() => _ArtistSchedulePageState();
}

class _ArtistSchedulePageState extends State<ArtistSchedulePage> {
  _ScheduleView _view = _ScheduleView.today;

  // -------------------- SAMPLE DATA --------------------

  final List<Map<String, String>> _today = [
    {
      'time': '10:00 – 11:30 AM',
      'client': 'Ravi',
      'location': 'Home Studio',
      'design': 'Gold foil nude · Almond',
      'status': 'Confirmed',
    },
    {
      'time': '1:00 – 2:00 PM',
      'client': 'Sarah',
      'location': 'Downtown Salon',
      'design': 'Short squoval · Baby pink',
      'status': 'Awaiting Deposit',
    },
  ];

  /// Week = one entry per weekday, with a list of that day’s appts.
  final List<Map<String, dynamic>> _week = [
    {
      'day': 'Mon',
      'label': 'Monday',
      'count': 2,
      'appointments': [
        {
          'time': '10:00 – 11:30 AM',
          'client': 'Ravi',
          'summary': 'Gold foil nude · Almond',
        },
        {
          'time': '3:00 – 4:00 PM',
          'client': 'Anna',
          'summary': 'Chrome French · Long',
        },
      ],
    },
    {
      'day': 'Wed',
      'label': 'Wednesday',
      'count': 1,
      'appointments': [
        {
          'time': '2:00 – 3:00 PM',
          'client': 'Sarah',
          'summary': 'Short squoval · Baby pink',
        },
      ],
    },
    {
      'day': 'Fri',
      'label': 'Friday',
      'count': 2,
      'appointments': [
        {
          'time': '11:00 – 12:00 PM',
          'client': 'Maya',
          'summary': 'Pastel abstract · Medium',
        },
        {
          'time': '5:00 – 6:00 PM',
          'client': 'Lena',
          'summary': 'Minimal nude · Oval',
        },
      ],
    },
  ];

  /// Month = upcoming highlights
  final List<Map<String, dynamic>> _monthUpcoming = [
    {
      'date': 'May 18',
      'client': 'Anna',
      'summary': 'Chrome French · Long',
      'note': 'Ship press-on set · Priority shipping',
    },
    {
      'date': 'May 21',
      'client': 'Maya',
      'summary': 'Pastel abstract · Medium',
      'note': 'In-studio · Bring inspo photos',
    },
    {
      'date': 'May 30',
      'client': 'Ravi',
      'summary': 'Gold foil refill · Almond',
      'note': 'Maintenance appointment',
    },
  ];

  // selected items (for week & month views)
  int? _selectedWeekIndex;
  int? _selectedMonthIndex;

  // -------------------- HELPERS --------------------

  Color _statusColor(String status) {
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

  // -------------------- TODAY --------------------

  Widget _buildTodayCard(Map<String, String> a) {
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
            a['time'] ?? '',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            a['client'] ?? '',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            a['location'] ?? '',
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF777777),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            a['design'] ?? '',
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF555555),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor(a['status'] ?? '').withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  a['status'] ?? '',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _statusColor(a['status'] ?? ''),
                  ),
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: const Text('Details'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTodayView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text(
          'Today\'s Appointments',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),
        ..._today.map(_buildTodayCard).toList(),
      ],
    );
  }

  // -------------------- WEEK --------------------

  Widget _buildWeekView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text(
          'This Week',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),

        // horizontal days (no fixed height to avoid overflow)
SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Row(
    children: List<Widget>.generate(_week.length, (index) {
      final day = _week[index];
      final String dayShort = day['day'] as String? ?? '';
      final int count = day['count'] as int? ?? 0;
      final bool isSelected = _selectedWeekIndex == index;

      return GestureDetector(
        onTap: () {
          setState(() => _selectedWeekIndex = index);
        },
        child: Container(
          width: 80,
          margin: const EdgeInsets.only(right: 10),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? kPink : const Color(0xFFE0E0E0),
              width: 1.5,
            ),
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
            mainAxisSize: MainAxisSize.min, // <- helps on very small heights
            children: [
              Text(
                dayShort,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? kPink : const Color(0xFF777777),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$count',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const Text(
                'Appointments',
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF777777),
                ),
              ),
            ],
          ),
        ),
      );
    }),
  ),
),

        // details for selected day
        if (_selectedWeekIndex != null) ...[
          const SizedBox(height: 20),
          _buildWeekDetail(),
        ],
      ],
    );
  }

  Widget _buildWeekDetail() {
    final day = _week[_selectedWeekIndex!];
    final String label = (day['label'] as String?) ?? (day['day'] as String? ?? '');
    final List<dynamic> raw =
        (day['appointments'] as List<dynamic>?) ?? const [];
    final List<Map<String, String>> appts = raw
        .map((e) => Map<String, String>.from(
            (e as Map).map((key, value) => MapEntry('$key', '$value'))))
        .toList();

    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5FA),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Appointments on $label',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 15),
          ...appts.map((a) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.schedule,
                      size: 16, color: Color(0xFF777777)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          a['time'] ?? '',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${a['client'] ?? ''} • ${a['summary'] ?? ''}',
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
          }).toList(),
        ],
      ),
    );
  }

  // -------------------- MONTH --------------------

  Widget _buildMonthView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text(
          'Upcoming This Month',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),

        ...List<Widget>.generate(_monthUpcoming.length, (index) {
          final item = _monthUpcoming[index];
          final bool isSelected = _selectedMonthIndex == index;

          return GestureDetector(
            onTap: () {
              setState(() => _selectedMonthIndex = index);
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color:
                      isSelected ? kPink : const Color(0x00000000),
                  width: 1.5,
                ),
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
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: kPink.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      item['date'] as String? ?? '',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: kPink,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['client'] as String? ?? '',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          item['summary'] as String? ?? '',
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
            ),
          );
        }),

        if (_selectedMonthIndex != null) ...[
          const SizedBox(height: 16),
          _buildMonthDetail(),
        ],
      ],
    );
  }

  Widget _buildMonthDetail() {
    final item = _monthUpcoming[_selectedMonthIndex!];
    final String date = item['date'] as String? ?? '';
    final String client = item['client'] as String? ?? '';
    final String summary = item['summary'] as String? ?? '';
    final String note = item['note'] as String? ?? '';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5FA),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Details for $date',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$client • $summary',
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF555555),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            note,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF777777),
            ),
          ),
        ],
      ),
    );
  }

  // -------------------- BUILD --------------------

  @override
  Widget build(BuildContext context) {
    Widget content;
    switch (_view) {
      case _ScheduleView.today:
        content = _buildTodayView();
        break;
      case _ScheduleView.week:
        content = _buildWeekView();
        break;
      case _ScheduleView.month:
        content = _buildMonthView();
        break;
    }

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Schedule',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'View your appointments by day, week, or month.',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF777777),
              ),
            ),
            const SizedBox(height: 16),

            // view selector
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('Today'),
                  selected: _view == _ScheduleView.today,
                  selectedColor: kPink.withOpacity(0.15),
                  labelStyle: TextStyle(
                    color: _view == _ScheduleView.today
                        ? kPink
                        : const Color(0xFF333333),
                    fontWeight: FontWeight.w600,
                  ),
                  onSelected: (_) =>
                      setState(() => _view = _ScheduleView.today),
                ),
                ChoiceChip(
                  label: const Text('This Week'),
                  selected: _view == _ScheduleView.week,
                  selectedColor: kPink.withOpacity(0.15),
                  labelStyle: TextStyle(
                    color: _view == _ScheduleView.week
                        ? kPink
                        : const Color(0xFF333333),
                    fontWeight: FontWeight.w600,
                  ),
                  onSelected: (_) =>
                      setState(() => _view = _ScheduleView.week),
                ),
                ChoiceChip(
                  label: const Text('This Month'),
                  selected: _view == _ScheduleView.month,
                  selectedColor: kPink.withOpacity(0.15),
                  labelStyle: TextStyle(
                    color: _view == _ScheduleView.month
                        ? kPink
                        : const Color(0xFF333333),
                    fontWeight: FontWeight.w600,
                  ),
                  onSelected: (_) =>
                      setState(() => _view = _ScheduleView.month),
                ),
              ],
            ),

            content,
          ],
        ),
      ),
    );
  }
}