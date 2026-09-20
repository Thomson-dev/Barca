import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/app_bottom_nav_bar.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  int _activeTab = 0;

  final String _selectedTeam = 'FIRST TEAM';

  // Instead of storing "July 2026" as a String,
  // we store the actual month.
  DateTime _selectedMonth = DateTime(2026, 7);

  // Temporary match data.
  // Later this will come from Supabase.
  final Map<int, MatchData> _matches = {
    31: MatchData(
      opponent: 'Real Madrid',
      opponentLogo: 'lib/assets/images/madrid.png',
      isHome: false,
    ),
  };

  // ------------------------------------------------------------
  // CALENDAR CALCULATIONS
  // ------------------------------------------------------------

  int get _firstDayIndex {
    // DateTime.weekday:
    // Monday = 1
    // Tuesday = 2
    // ...
    // Sunday = 7
    //
    // Our calendar grid:
    // Monday = 0
    // Tuesday = 1
    // ...
    // Sunday = 6

    return _selectedMonth.weekday - 1;
  }

  int get _daysInMonth {
    return DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0).day;
  }

  int get _totalCalendarCells {
    final totalDays = _firstDayIndex + _daysInMonth;

    // Round up to the next multiple of 7.
    return ((totalDays + 6) ~/ 7) * 7;
  }

  String get _monthName {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return months[_selectedMonth.month - 1];
  }

  String get _selectedMonthLabel {
    return '$_monthName ${_selectedMonth.year}';
  }

  // ------------------------------------------------------------
  // MONTH NAVIGATION
  // ------------------------------------------------------------

  void _goToPreviousMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
    });
  }

  void _goToNextMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
    });
  }

  // ------------------------------------------------------------
  // BUILD
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ----------------------------------------------------------
      // APP BAR
      // ----------------------------------------------------------
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 8,
        leadingWidth: 52,

        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Image.asset(
            'lib/assets/images/member.png',
            width: 20,
            height: 20,
            errorBuilder: (_, __, ___) {
              return const Icon(Iconsax.shield, size: 24, color: Colors.amber);
            },
          ),
        ),

        title: Text(
          'CALENDAR',
          style: GoogleFonts.oswald(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            letterSpacing: 0.5,
            color: const Color(0xFF050505),
          ),
        ),

        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _selectedTeam,
                  style: GoogleFonts.oswald(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(width: 4),

                const Icon(Iconsax.arrow_down_2, size: 18, color: Colors.black),
              ],
            ),
          ),
        ],
      ),

      // ----------------------------------------------------------
      // BODY
      // ----------------------------------------------------------
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ------------------------------------------------------
          // SUB TABS
          // ------------------------------------------------------

          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
            ),
            child: Row(
              children: [
                _SubTab(
                  label: 'CALENDAR',
                  isSelected: _activeTab == 0,
                  onTap: () {
                    setState(() {
                      _activeTab = 0;
                    });
                  },
                ),

                _SubTab(
                  label: 'STANDINGS',
                  isSelected: _activeTab == 1,
                  onTap: () {
                    setState(() {
                      _activeTab = 1;
                    });
                  },
                ),

                _SubTab(
                  label: 'PLAYERS',
                  isSelected: _activeTab == 2,
                  onTap: () {
                    setState(() {
                      _activeTab = 2;
                    });
                  },
                ),
              ],
            ),
          ),

          // ------------------------------------------------------
          // TAB CONTENT
          // ------------------------------------------------------
          if (_activeTab == 0)
            _CalendarContent(
              selectedMonthLabel: _selectedMonthLabel,
              firstDayIndex: _firstDayIndex,
              daysInMonth: _daysInMonth,
              totalCalendarCells: _totalCalendarCells,
              matches: _matches,
              onPreviousMonth: _goToPreviousMonth,
              onNextMonth: _goToNextMonth,
            )
          else if (_activeTab == 1)
            const _StandingsContent()
          else
            const _PlayersContent(),
        ],
      ),

      // ----------------------------------------------------------
      // BOTTOM NAVIGATION
      // ----------------------------------------------------------
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 1),
    );
  }
}

// ================================================================
// CALENDAR CONTENT
// ================================================================

class _CalendarContent extends StatelessWidget {
  const _CalendarContent({
    required this.selectedMonthLabel,
    required this.firstDayIndex,
    required this.daysInMonth,
    required this.totalCalendarCells,
    required this.matches,
    required this.onPreviousMonth,
    required this.onNextMonth,
  });

  final String selectedMonthLabel;
  final int firstDayIndex;
  final int daysInMonth;
  final int totalCalendarCells;
  final Map<int, MatchData> matches;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          const SizedBox(height: 16),

          // --------------------------------------------------------
          // MONTH SELECTOR
          // --------------------------------------------------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                IconButton(
                  onPressed: onPreviousMonth,
                  icon: const Icon(Iconsax.arrow_left_3, size: 28),
                ),

                Expanded(
                  child: Center(
                    child: Text(
                      selectedMonthLabel,
                      style: GoogleFonts.oswald(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),

                IconButton(
                  onPressed: onNextMonth,
                  icon: const Icon(Iconsax.arrow_right_3, size: 28),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // --------------------------------------------------------
          // CALENDAR GRID
          // --------------------------------------------------------
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // ------------------------------------------------
                  // WEEKDAY HEADER
                  // ------------------------------------------------

                  Row(
                    children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                        .map((day) {
                          return Expanded(
                            child: Center(
                              child: Text(
                                day,
                                style: GoogleFonts.oswald(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                          );
                        })
                        .toList(),
                  ),

                  const SizedBox(height: 16),

                  // ------------------------------------------------
                  // DAYS GRID
                  // ------------------------------------------------
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),

                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 7,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 12,
                        ),

                    itemCount: totalCalendarCells,

                    itemBuilder: (context, index) {
                      // Empty cells before the first day
                      if (index < firstDayIndex) {
                        return const SizedBox.shrink();
                      }

                      final dayNum = index - firstDayIndex + 1;

                      // Next month's overflow days
                      if (dayNum > daysInMonth) {
                        final nextMonthDay = dayNum - daysInMonth;

                        return Center(
                          child: Text(
                            '$nextMonthDay',
                            style: GoogleFonts.oswald(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        );
                      }

                      final match = matches[dayNum];

                      // Normal day (no match)
                      if (match == null) {
                        return Center(
                          child: Text(
                            '$dayNum',
                            style: GoogleFonts.oswald(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                            ),
                          ),
                        );
                      }

                      // Day with a match
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            '$dayNum',
                            style: GoogleFonts.oswald(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                            ),
                          ),

                          const SizedBox(height: 2),

                          Image.asset(
                            match.opponentLogo,
                            width: 24,
                            height: 24,
                            errorBuilder: (_, __, ___) {
                              return const Icon(
                                Iconsax.shield,
                                size: 20,
                                color: Colors.amber,
                              );
                            },
                          ),

                          const SizedBox(height: 4),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFA50044),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  match.isHome
                                      ? Iconsax.home
                                      : Iconsax.airplane,
                                  size: 10,
                                  color: Colors.white,
                                ),

                                const SizedBox(width: 2),

                                Text(
                                  match.isHome ? 'HOME' : 'AWAY',
                                  style: GoogleFonts.oswald(
                                    fontSize: 8,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ================================================================
// STANDINGS CONTENT
// ================================================================

class _StandingsContent extends StatelessWidget {
  const _StandingsContent();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Iconsax.chart, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              'STANDINGS',
              style: GoogleFonts.oswald(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Coming soon',
              style: GoogleFonts.oswald(
                fontSize: 14,
                color: Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================================================================
// PLAYERS CONTENT
// ================================================================

class _PlayersContent extends StatelessWidget {
  const _PlayersContent();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Iconsax.people, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              'PLAYERS',
              style: GoogleFonts.oswald(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Coming soon',
              style: GoogleFonts.oswald(
                fontSize: 14,
                color: Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================================================================
// MATCH DATA
// ================================================================

class MatchData {
  final String opponent;
  final String opponentLogo;
  final bool isHome;

  const MatchData({
    required this.opponent,
    required this.opponentLogo,
    required this.isHome,
  });
}

// ================================================================
// SUB TAB
// ================================================================

class _SubTab extends StatelessWidget {
  const _SubTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? Colors.black : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.oswald(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            color: isSelected ? Colors.black : Colors.grey.shade400,
          ),
        ),
      ),
    );
  }
}
