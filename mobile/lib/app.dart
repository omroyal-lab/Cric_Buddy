import 'package:flutter/material.dart';

import 'domain/scoring/score_session.dart';
import 'features/scoring/scoring_screen.dart';
import 'theme/app_colors.dart';

class SavedMatch {
  const SavedMatch({
    required this.teams,
    required this.venue,
    required this.format,
    required this.time,
    required this.status,
  });

  final String teams;
  final String venue;
  final String format;
  final String time;
  final String status;

  SavedMatch copyWith({
    String? teams,
    String? venue,
    String? format,
    String? time,
    String? status,
  }) => SavedMatch(
    teams: teams ?? this.teams,
    venue: venue ?? this.venue,
    format: format ?? this.format,
    time: time ?? this.time,
    status: status ?? this.status,
  );
}

class CricScoreApp extends StatelessWidget {
  const CricScoreApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'CricScore',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: cricketBlue,
        primary: cricketBlue,
        surface: Colors.white,
        error: const Color(0xFFC43D3D),
      ),
      scaffoldBackgroundColor: canvasColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: canvasColor,
        foregroundColor: cricketNavy,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: lineColor),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFEAF1FF),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontSize: 11,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
          ),
        ),
      ),
    ),
    home: const CricScoreShell(),
  );
}

class CricScoreShell extends StatefulWidget {
  const CricScoreShell({super.key});
  @override
  State<CricScoreShell> createState() => _CricScoreShellState();
}

class _CricScoreShellState extends State<CricScoreShell> {
  final ScoreSession _session = ScoreSession();
  int _tab = 0;
  String _matchFormat = 'T20';
  String _matchVenue = 'Oval Community Ground';
  List<SavedMatch> _savedMatches = [
    SavedMatch(
      teams: 'Harbour XI vs Riverside CC',
      venue: 'Oval Community Ground',
      format: 'T20',
      time: 'Today · 7:20 PM',
      status: 'Live',
    ),
    SavedMatch(
      teams: 'Northside Strikers vs East End CC',
      venue: 'Northbank Oval',
      format: 'T20',
      time: 'Tomorrow · 4:30 PM',
      status: 'Scheduled',
    ),
  ];
  static const _labels = ['Home', 'Live', 'Tournaments', 'My Teams', 'Profile'];
  static const _icons = [
    Icons.home_outlined,
    Icons.sports_cricket_outlined,
    Icons.emoji_events_outlined,
    Icons.groups_2_outlined,
    Icons.person_outline,
  ];

  @override
  void dispose() {
    _session.dispose();
    super.dispose();
  }

  void _handleMatchSetup(String format, String venue) {
    setState(() {
      _matchFormat = format;
      _matchVenue = venue;
      _savedMatches = [
        SavedMatch(
          teams: 'Harbour XI vs Riverside CC',
          venue: venue,
          format: format,
          time: 'Today · 7:20 PM',
          status: 'Live',
        ),
        ..._savedMatches.skip(1),
      ];
    });
  }

  void _openSavedMatch(int index, SavedMatch match) {
    setState(() {
      _tab = 1;
      _matchFormat = match.format;
      _matchVenue = match.venue;
      _savedMatches[index] = match;
    });
  }

  Future<void> _editSavedMatch(int index, SavedMatch match) async {
    final venueController = TextEditingController(text: match.venue);
    final format = ValueNotifier<String>(match.format);

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: ValueListenableBuilder<String>(
            valueListenable: format,
            builder: (context, selectedFormat, _) => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Edit match',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                Text(
                  match.teams,
                  style: const TextStyle(
                    color: Color(0xFF68766F),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE3EAE5)),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedFormat,
                        isExpanded: true,
                        items: const [
                          DropdownMenuItem(value: 'T20', child: Text('T20')),
                          DropdownMenuItem(value: 'ODI', child: Text('ODI')),
                          DropdownMenuItem(value: 'T10', child: Text('T10')),
                          DropdownMenuItem(
                            value: 'Club Match',
                            child: Text('Club Match'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            format.value = value;
                          }
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: venueController,
                  decoration: const InputDecoration(
                    labelText: 'Venue',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 18),
                FilledButton(
                  onPressed: () {
                    final updatedVenue = venueController.text.trim().isEmpty
                        ? match.venue
                        : venueController.text.trim();
                    setState(() {
                      _savedMatches[index] = _savedMatches[index].copyWith(
                        venue: updatedVenue,
                        format: format.value,
                      );
                    });
                    Navigator.pop(context);
                  },
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Save changes'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openMatchCentre() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const MatchCentrePage()));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      toolbarHeight: 58,
      titleSpacing: 18,
      title: const _BrandMark(),
      actions: const [
        Padding(padding: EdgeInsets.only(right: 10), child: _SampleTag()),
        SizedBox(width: 3),
        Padding(
          padding: EdgeInsets.only(right: 16),
          child: CircleAvatar(
            radius: 18,
            backgroundColor: Color(0xFFE6F1E9),
            child: Text(
              'AR',
              style: TextStyle(
                color: cricketGreen,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ],
    ),
    body: IndexedStack(
      index: _tab,
      children: [
        _HomePage(
          onStart: () => setState(() => _tab = 1),
          onOpenMatchCentre: _openMatchCentre,
          onCreateMatch: _handleMatchSetup,
          onOpenSavedMatch: _openSavedMatch,
          onEditMatch: _editSavedMatch,
          matchFormat: _matchFormat,
          matchVenue: _matchVenue,
          savedMatches: _savedMatches,
        ),
        ScoringScreen(session: _session),
        const _TournamentsPage(),
        const _TeamsPage(),
        const _ProfilePage(),
      ],
    ),
    bottomNavigationBar: NavigationBar(
      selectedIndex: _tab,
      onDestinationSelected: (index) => setState(() => _tab = index),
      destinations: List.generate(
        _labels.length,
        (index) => NavigationDestination(
          icon: Icon(_icons[index]),
          label: _labels[index],
        ),
      ),
    ),
  );
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 29,
        height: 29,
        decoration: BoxDecoration(
          color: cricketGreen,
          borderRadius: BorderRadius.circular(9),
        ),
        child: const Icon(Icons.sports_cricket, color: Colors.white, size: 17),
      ),
      const SizedBox(width: 9),
      const Text.rich(
        TextSpan(
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: cricketNavy,
          ),
          children: [
            TextSpan(text: 'Cric'),
            TextSpan(
              text: 'Score',
              style: TextStyle(
                color: cricketGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class _SampleTag extends StatelessWidget {
  const _SampleTag();
  @override
  Widget build(BuildContext context) => Center(
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3D9),
        borderRadius: BorderRadius.circular(30),
      ),
      child: const Text(
        'SAMPLE',
        style: TextStyle(
          color: Color(0xFF79540C),
          fontSize: 9,
          fontWeight: FontWeight.w800,
          letterSpacing: .5,
        ),
      ),
    ),
  );
}

class _HomePage extends StatelessWidget {
  const _HomePage({
    required this.onStart,
    required this.onOpenMatchCentre,
    required this.onCreateMatch,
    required this.onOpenSavedMatch,
    required this.onEditMatch,
    required this.matchFormat,
    required this.matchVenue,
    required this.savedMatches,
  });
  final VoidCallback onStart;
  final VoidCallback onOpenMatchCentre;
  final void Function(String format, String venue) onCreateMatch;
  final void Function(int index, SavedMatch match) onOpenSavedMatch;
  final Future<void> Function(int index, SavedMatch match) onEditMatch;
  final String matchFormat;
  final String matchVenue;
  final List<SavedMatch> savedMatches;
  @override
  Widget build(BuildContext context) {
    final savedMatchCards = savedMatches.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFFE7F1E9),
              child: Text(
                item.status.characters.first,
                style: const TextStyle(
                  color: cricketGreen,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            title: Text(
              item.teams,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: cricketNavy,
              ),
            ),
            subtitle: Text(
              '${item.venue} · ${item.format}\n${item.time}',
              style: const TextStyle(fontSize: 11),
            ),
            trailing: Wrap(
              spacing: 0,
              children: [
                TextButton(
                  key: ValueKey('saved-match-open-$index'),
                  onPressed: () => onOpenSavedMatch(index, item),
                  child: const Text('Open'),
                ),
                TextButton(
                  key: ValueKey('saved-match-edit-$index'),
                  onPressed: () => onEditMatch(index, item),
                  child: const Text('Edit'),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        Text(
          'Good afternoon, Alex',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: cricketNavy,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Your cricket, all in one place.',
          style: TextStyle(color: Color(0xFF68766F)),
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: () => _setupPreview(context, onStart, onCreateMatch),
          icon: const Icon(Icons.add),
          label: const Text('Create new match'),
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: onOpenMatchCentre,
          icon: const Icon(Icons.dashboard_outlined),
          label: const Text('Open match centre'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            side: const BorderSide(color: Color(0xFFCEE3D5)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (savedMatches.isNotEmpty)
          FilledButton.tonalIcon(
            key: const ValueKey('quick-open-saved-match'),
            onPressed: () => onOpenSavedMatch(0, savedMatches.first),
            icon: const Icon(Icons.play_arrow_rounded),
            label: const Text('Open live match'),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(44),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        const SizedBox(height: 18),
        const _SectionTitle('Continue scoring', trailing: 'SAMPLE MATCH'),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Harbour XI vs Riverside CC',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: cricketNavy,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '126/4  ·  14.2 overs',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: cricketGreen,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$matchVenue · $matchFormat',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF68766F),
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: OutlinedButton(
                    onPressed: onStart,
                    child: const Text('Open scoring'),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        const _SectionTitle('Your cricket'),
        const SizedBox(height: 8),
        const Row(
          children: [
            Expanded(
              child: _QuickStat(
                label: 'My teams',
                value: '03',
                icon: Icons.groups_2_outlined,
              ),
            ),
            SizedBox(width: 9),
            Expanded(
              child: _QuickStat(
                label: 'Tournaments',
                value: '01',
                icon: Icons.emoji_events_outlined,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const _SectionTitle('Saved matches'),
        const SizedBox(height: 8),
        ...savedMatchCards,
        const SizedBox(height: 16),
        const _SectionTitle('Upcoming match'),
        const SizedBox(height: 8),
        const Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Color(0xFFE7F1E9),
              child: Icon(Icons.sports_cricket, color: cricketGreen),
            ),
            title: Text(
              'Northside Strikers vs East End CC',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
            subtitle: Text(
              'Today, 4:30 PM · T20',
              style: TextStyle(fontSize: 11),
            ),
            trailing: Icon(Icons.chevron_right),
          ),
        ),
      ],
    );
  }
}

class MatchCentrePage extends StatelessWidget {
  const MatchCentrePage({super.key});

  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: 4,
    child: Scaffold(
      appBar: AppBar(
        title: const Text('Match centre'),
        bottom: const TabBar(
          isScrollable: true,
          tabs: [
            Tab(text: 'Overview'),
            Tab(text: 'Scorecard'),
            Tab(text: 'Teams'),
            Tab(text: 'Insights'),
          ],
        ),
      ),
      body: const TabBarView(
        children: [
          _OverviewTab(),
          _ScorecardTab(),
          _TeamsTab(),
          _InsightsTab(),
        ],
      ),
    ),
  );
}

class _OverviewTab extends StatelessWidget {
  const _OverviewTab();

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Expanded(
                    child: Text(
                      'Harbour XI vs Riverside CC',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: cricketNavy,
                      ),
                    ),
                  ),
                  Text(
                    'LIVE',
                    style: TextStyle(
                      color: cricketGreen,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Oval Community Ground · Twenty20 · 2nd innings',
                style: TextStyle(fontSize: 12, color: Color(0xFF68766F)),
              ),
              const SizedBox(height: 16),
              const Text(
                '126/4',
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w800,
                  color: cricketGreen,
                ),
              ),
              const Text(
                'Target 171 · 14.2 overs · Needed 45 from 34 balls',
                style: TextStyle(fontSize: 12, color: cricketNavy),
              ),
              const SizedBox(height: 16),
              Row(
                children: const [
                  Expanded(
                    child: _QuickStat(
                      label: 'Run rate',
                      value: '8.73',
                      icon: Icons.speed_outlined,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: _QuickStat(
                      label: 'REQ RR',
                      value: '7.94',
                      icon: Icons.trending_up,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 16),
      const _SectionTitle('Key details', trailing: 'LAST 10 BALLS'),
      const SizedBox(height: 8),
      Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: const [
              _InfoRow(
                label: 'Toss',
                value: 'Harbour XI won and chose to bowl',
              ),
              Divider(height: 1),
              _InfoRow(
                label: 'Current bowlers',
                value: 'Samir Khan 3.2-0-28-1',
              ),
              Divider(height: 1),
              _InfoRow(label: 'Partnership', value: '18 off 12 balls'),
            ],
          ),
        ),
      ),
    ],
  );
}

class _ScorecardTab extends StatelessWidget {
  const _ScorecardTab();

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      const _SectionTitle('Batting order'),
      const SizedBox(height: 8),
      Card(
        child: Column(
          children: const [
            _PlayerScoreRow(
              name: 'Arjun Rao',
              score: '48*',
              balls: '31b',
              fours: '5',
              sixes: '2',
              strike: '154.8',
            ),
            Divider(height: 1),
            _PlayerScoreRow(
              name: 'Dev Mehta',
              score: '19*',
              balls: '15b',
              fours: '2',
              sixes: '0',
              strike: '126.7',
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      const _SectionTitle('Overs'),
      const SizedBox(height: 8),
      Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              _OverBall(label: '14.1', value: '1'),
              _OverBall(label: '14.2', value: '4'),
              _OverBall(label: '14.3', value: '0'),
              _OverBall(label: '14.4', value: '2'),
              _OverBall(label: '14.5', value: 'W'),
              _OverBall(label: '14.6', value: '1'),
            ],
          ),
        ),
      ),
    ],
  );
}

class _TeamsTab extends StatelessWidget {
  const _TeamsTab();

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      const _SectionTitle('Starting XI'),
      const SizedBox(height: 8),
      Card(
        child: Column(
          children: const [
            _PlayerMetaRow(
              name: 'Arjun Rao',
              role: 'Opening batter',
              status: 'On strike',
            ),
            Divider(height: 1),
            _PlayerMetaRow(
              name: 'Dev Mehta',
              role: 'Middle order',
              status: 'Retained',
            ),
            Divider(height: 1),
            _PlayerMetaRow(
              name: 'Nikhil Shah',
              role: 'All-rounder',
              status: 'Ready',
            ),
          ],
        ),
      ),
    ],
  );
}

class _InsightsTab extends StatelessWidget {
  const _InsightsTab();

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      const _SectionTitle('Match insights'),
      const SizedBox(height: 8),
      Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: const [
              _InfoRow(label: 'Expected finish', value: '168/8'),
              Divider(height: 1),
              _InfoRow(
                label: 'Boundary risk',
                value: 'Moderate · 3 boundaries in last 5 overs',
              ),
              Divider(height: 1),
              _InfoRow(label: 'Pressure index', value: '62/100'),
            ],
          ),
        ),
      ),
    ],
  );
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF68766F),
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: cricketNavy,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    ),
  );
}

class _PlayerScoreRow extends StatelessWidget {
  const _PlayerScoreRow({
    required this.name,
    required this.score,
    required this.balls,
    required this.fours,
    required this.sixes,
    required this.strike,
  });

  final String name;
  final String score;
  final String balls;
  final String fours;
  final String sixes;
  final String strike;

  @override
  Widget build(BuildContext context) => ListTile(
    title: Text(
      name,
      style: const TextStyle(fontWeight: FontWeight.w800, color: cricketNavy),
    ),
    subtitle: Text(
      '$balls balls · 4s $fours · 6s $sixes',
      style: const TextStyle(fontSize: 11),
    ),
    trailing: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          score,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            color: cricketGreen,
          ),
        ),
        Text(
          'SR $strike',
          style: const TextStyle(fontSize: 10, color: Color(0xFF68766F)),
        ),
      ],
    ),
  );
}

class _OverBall extends StatelessWidget {
  const _OverBall({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Container(
    width: 56,
    padding: const EdgeInsets.symmetric(vertical: 8),
    decoration: BoxDecoration(
      color: const Color(0xFFEAF4EE),
      borderRadius: BorderRadius.circular(9),
    ),
    child: Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 9, color: Color(0xFF68766F)),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            color: cricketNavy,
          ),
        ),
      ],
    ),
  );
}

class _PlayerMetaRow extends StatelessWidget {
  const _PlayerMetaRow({
    required this.name,
    required this.role,
    required this.status,
  });

  final String name;
  final String role;
  final String status;

  @override
  Widget build(BuildContext context) => ListTile(
    leading: CircleAvatar(
      backgroundColor: const Color(0xFFEAF4EE),
      child: Text(
        name.characters.first,
        style: const TextStyle(
          color: cricketGreen,
          fontWeight: FontWeight.w800,
        ),
      ),
    ),
    title: Text(
      name,
      style: const TextStyle(fontWeight: FontWeight.w800, color: cricketNavy),
    ),
    subtitle: Text(role, style: const TextStyle(fontSize: 11)),
    trailing: Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF4EE),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: const TextStyle(
          color: cricketGreen,
          fontSize: 9,
          fontWeight: FontWeight.w800,
        ),
      ),
    ),
  );
}

Future<void> _setupPreview(
  BuildContext context,
  VoidCallback onStart,
  void Function(String format, String venue) onCreateMatch,
) async {
  final format = ValueNotifier<String>('T20');
  final venueText = TextEditingController(text: 'Oval Community Ground');

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: ValueListenableBuilder<String>(
          valueListenable: format,
          builder: (context, selectedFormat, _) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'New match',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              const Text(
                'Set the competition details and open the live score sheet.',
                style: TextStyle(color: Color(0xFF68766F)),
              ),
              const SizedBox(height: 16),
              DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE3EAE5)),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedFormat,
                      isExpanded: true,
                      items: const [
                        DropdownMenuItem(value: 'T20', child: Text('T20')),
                        DropdownMenuItem(value: 'ODI', child: Text('ODI')),
                        DropdownMenuItem(value: 'T10', child: Text('T10')),
                        DropdownMenuItem(
                          value: 'Club Match',
                          child: Text('Club Match'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          format.value = value;
                        }
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: venueText,
                decoration: const InputDecoration(
                  labelText: 'Venue',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF5F1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.groups_2_outlined, color: cricketGreen),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Harbour XI vs Riverside CC',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: cricketNavy,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        selectedFormat,
                        style: const TextStyle(
                          color: cricketGreen,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              FilledButton(
                onPressed: () {
                  final resolvedVenue = venueText.text.trim().isEmpty
                      ? 'Oval Community Ground'
                      : venueText.text.trim();
                  onCreateMatch(format.value, resolvedVenue);
                  Navigator.pop(context);
                },
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Start live scoring'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _TournamentsPage extends StatefulWidget {
  const _TournamentsPage();

  @override
  State<_TournamentsPage> createState() => _TournamentsPageState();
}

class _TournamentsPageState extends State<_TournamentsPage> {
  final ValueNotifier<String> _resultType = ValueNotifier<String>(
    'Harbour XI won by 7 wickets',
  );
  final ValueNotifier<String> _latestResult = ValueNotifier<String>(
    'Harbour XI won by 7 wickets',
  );

  @override
  void dispose() {
    _resultType.dispose();
    _latestResult.dispose();
    super.dispose();
  }

  Future<void> _openFixtureBoard(BuildContext context) async {
    const fixtures = [
      (
        'Harbour XI vs East End CC',
        'Today · 4:30 PM',
        'Live board',
        'Northbank Oval',
        'Live',
      ),
      (
        'Riverside CC vs Northside Strikers',
        'Sun · 10:00 AM',
        'Toss at 9:45 AM',
        'South Park',
        'Upcoming',
      ),
      (
        'Harbour XI vs Dockside CC',
        'Wed · 7:00 PM',
        'League round',
        'Oval Community Ground',
        'Scheduled',
      ),
    ];

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Match-day board',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              ...fixtures.map((fixture) {
                final match = fixture.$1;
                final time = fixture.$2;
                final statusLabel = fixture.$3;
                final venue = fixture.$4;
                final badge = fixture.$5;
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F9FF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE1EAFD)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              match,
                              style: const TextStyle(
                                color: cricketNavy,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$time · $venue',
                              style: const TextStyle(
                                color: Color(0xFF68766F),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: badge == 'Live'
                              ? const Color(0xFFEAF4EE)
                              : badge == 'Upcoming'
                              ? const Color(0xFFFFF1E8)
                              : const Color(0xFFEAF1FF),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          badge,
                          style: TextStyle(
                            color: badge == 'Live'
                                ? cricketGreen
                                : badge == 'Upcoming'
                                ? const Color(0xFFB55C00)
                                : cricketBlue,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 8),
              Text(
                'Ground status · All matches are on track',
                style: TextStyle(
                  color: cricketNavy.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openResultEntrySheet(BuildContext context) async {
    final notesController = TextEditingController(
      text: 'Chased 172 in 18.4 overs after a late partnership.',
    );

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: ValueListenableBuilder<String>(
            valueListenable: _resultType,
            builder: (context, selectedResult, _) => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Result entry',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Harbour XI vs East End CC',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF68766F),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Choose result',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF68766F),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ChoiceChip(
                      label: const Text('Harbour XI won by 7 wickets'),
                      selected: selectedResult == 'Harbour XI won by 7 wickets',
                      onSelected: (_) {
                        _resultType.value = 'Harbour XI won by 7 wickets';
                      },
                      selectedColor: const Color(0xFFEAF1FF),
                      labelStyle: TextStyle(
                        color: selectedResult == 'Harbour XI won by 7 wickets'
                            ? cricketBlue
                            : cricketNavy,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    ChoiceChip(
                      label: const Text('Harbour XI won by 25 runs'),
                      selected: selectedResult == 'Harbour XI won by 25 runs',
                      onSelected: (_) {
                        _resultType.value = 'Harbour XI won by 25 runs';
                      },
                      selectedColor: const Color(0xFFEAF1FF),
                      labelStyle: TextStyle(
                        color: selectedResult == 'Harbour XI won by 25 runs'
                            ? cricketBlue
                            : cricketNavy,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    ChoiceChip(
                      label: const Text('Harbour XI lost'),
                      selected: selectedResult == 'Harbour XI lost',
                      onSelected: (_) {
                        _resultType.value = 'Harbour XI lost';
                      },
                      selectedColor: const Color(0xFFFFF1E8),
                      labelStyle: TextStyle(
                        color: selectedResult == 'Harbour XI lost'
                            ? cricketOrange
                            : cricketNavy,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    ChoiceChip(
                      label: const Text('No result'),
                      selected: selectedResult == 'No result',
                      onSelected: (_) {
                        _resultType.value = 'No result';
                      },
                      selectedColor: const Color(0xFFFFF1E8),
                      labelStyle: TextStyle(
                        color: selectedResult == 'No result'
                            ? cricketOrange
                            : cricketNavy,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: notesController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Match notes',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 18),
                FilledButton(
                  onPressed: () {
                    _latestResult.value = _resultType.value;
                    Navigator.pop(sheetContext);
                    ScaffoldMessenger.maybeOf(sheetContext)?.showSnackBar(
                      const SnackBar(
                        content: Text('Result published to the league table'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Publish result'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      Text(
        'Tournaments',
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w800,
          color: cricketNavy,
        ),
      ),
      const SizedBox(height: 4),
      const Text(
        'Season ladder, fixtures and standings.',
        style: TextStyle(color: Color(0xFF68766F)),
      ),
      const SizedBox(height: 16),
      Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF4EE),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Text(
                      'CITY LEAGUE 2026',
                      style: TextStyle(
                        color: cricketGreen,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: .5,
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    '5 rounds left',
                    style: TextStyle(
                      color: Color(0xFF68766F),
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Harbour XI',
                style: TextStyle(
                  color: cricketNavy,
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                '3rd place · 9 wins · 2 losses · Net run rate +1.16',
                style: TextStyle(color: Color(0xFF68766F), fontSize: 11),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _QuickStat(
                      label: 'Matches',
                      value: '11',
                      icon: Icons.calendar_month_outlined,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _QuickStat(
                      label: 'Points',
                      value: '18',
                      icon: Icons.emoji_events_outlined,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 18),
      const _SectionTitle('Match control', trailing: 'OPERATIONS'),
      const SizedBox(height: 8),
      Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _ActionTile(
                      label: 'Result entry',
                      icon: Icons.fact_check_outlined,
                      colour: cricketGreen,
                      onTap: () => _openResultEntrySheet(context),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ActionTile(
                      label: 'Fixture board',
                      icon: Icons.calendar_month_outlined,
                      colour: const Color(0xFF0D6B62),
                      onTap: () => _openFixtureBoard(context),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const _InfoRow(
                label: 'Next deadline',
                value: 'Submit scorecards by 6:15 PM',
              ),
              const Divider(height: 1),
              const _InfoRow(
                label: 'Scoring status',
                value: 'All club grounds connected and syncing',
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 18),
      ValueListenableBuilder<String>(
        valueListenable: _latestResult,
        builder: (context, latestResult, _) => Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF4EE),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.check_circle_outline,
                    color: cricketGreen,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Latest result',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF68766F),
                          letterSpacing: 0.4,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Latest result: $latestResult',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          color: cricketNavy,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      const SizedBox(height: 18),
      const _SectionTitle('Season ladder', trailing: 'TOP 5'),
      const SizedBox(height: 8),
      Card(
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            children: const [
              _StandingRow(
                rank: 1,
                team: 'Northside Strikers',
                played: 11,
                wins: 9,
                nrr: '+1.54',
              ),
              Divider(height: 1),
              _StandingRow(
                rank: 2,
                team: 'Riverside CC',
                played: 11,
                wins: 8,
                nrr: '+1.18',
              ),
              Divider(height: 1),
              _StandingRow(
                rank: 3,
                team: 'Harbour XI',
                played: 11,
                wins: 9,
                nrr: '+1.16',
                active: true,
              ),
              Divider(height: 1),
              _StandingRow(
                rank: 4,
                team: 'East End CC',
                played: 11,
                wins: 7,
                nrr: '+0.88',
              ),
              Divider(height: 1),
              _StandingRow(
                rank: 5,
                team: 'Cove United',
                played: 11,
                wins: 6,
                nrr: '+0.44',
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 18),
      const _SectionTitle('Upcoming fixtures', trailing: '3 matches'),
      const SizedBox(height: 8),
      Card(
        child: Column(
          children: const [
            _FixtureRow(
              teams: 'Harbour XI vs East End CC',
              time: 'Tomorrow · 4:30 PM',
              venue: 'Northbank Oval',
            ),
            Divider(height: 1),
            _FixtureRow(
              teams: 'Riverside CC vs Northside Strikers',
              time: 'Sun · 10:00 AM',
              venue: 'South Park',
            ),
            Divider(height: 1),
            _FixtureRow(
              teams: 'Harbour XI vs Dockside CC',
              time: 'Wed · 7:00 PM',
              venue: 'Oval Community Ground',
            ),
          ],
        ),
      ),
    ],
  );
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.label,
    required this.icon,
    required this.colour,
    this.onTap,
  });

  final String label;
  final IconData icon;
  final Color colour;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12),
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colour.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colour.withValues(alpha: 0.18)),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: colour,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: cricketNavy,
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _StandingRow extends StatelessWidget {
  const _StandingRow({
    required this.rank,
    required this.team,
    required this.played,
    required this.wins,
    required this.nrr,
    this.active = false,
  });

  final int rank;
  final String team;
  final int played;
  final int wins;
  final String nrr;
  final bool active;

  @override
  Widget build(BuildContext context) => Container(
    color: active ? const Color(0xFFEAF4EE) : null,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    child: Row(
      children: [
        SizedBox(
          width: 22,
          child: Text(
            '$rank',
            style: TextStyle(
              fontWeight: active ? FontWeight.w800 : FontWeight.w700,
              color: active ? cricketGreen : cricketNavy,
            ),
          ),
        ),
        Expanded(
          child: Text(
            team,
            style: const TextStyle(
              color: cricketNavy,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(
          width: 35,
          child: Text('$played', textAlign: TextAlign.center),
        ),
        SizedBox(width: 35, child: Text('$wins', textAlign: TextAlign.center)),
        Text(nrr, style: const TextStyle(fontWeight: FontWeight.w700)),
      ],
    ),
  );
}

class _FixtureRow extends StatelessWidget {
  const _FixtureRow({
    required this.teams,
    required this.time,
    required this.venue,
  });

  final String teams;
  final String time;
  final String venue;

  @override
  Widget build(BuildContext context) => ListTile(
    leading: CircleAvatar(
      radius: 18,
      backgroundColor: const Color(0xFFEAF4EE),
      child: const Icon(Icons.sports_cricket, color: cricketGreen),
    ),
    title: Text(
      teams,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        color: cricketNavy,
      ),
    ),
    subtitle: Text('$time · $venue', style: const TextStyle(fontSize: 11)),
    trailing: const Icon(Icons.chevron_right),
  );
}

class _TeamsPage extends StatelessWidget {
  const _TeamsPage();

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      Text(
        'My teams',
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w800,
          color: cricketNavy,
        ),
      ),
      const SizedBox(height: 4),
      const Text(
        'Club performance, squad depth and key players.',
        style: TextStyle(color: Color(0xFF68766F)),
      ),
      const SizedBox(height: 16),
      Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF4EE),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.shield_outlined,
                      color: cricketGreen,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Harbour XI',
                          style: TextStyle(
                            color: cricketNavy,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          'City League · Captain: Arjun Rao',
                          style: TextStyle(
                            color: Color(0xFF68766F),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: const [
                  Expanded(
                    child: _QuickStat(
                      label: 'Wins',
                      value: '9',
                      icon: Icons.check_circle_outline,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: _QuickStat(
                      label: 'Run rate',
                      value: '+1.16',
                      icon: Icons.trending_up,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 18),
      const _SectionTitle('Squad', trailing: '11 players'),
      const SizedBox(height: 8),
      Card(
        child: Column(
          children: const [
            _PlayerRow(
              name: 'Arjun Rao',
              role: 'Captain · Top order',
              runs: '482 runs',
              badge: 'C',
            ),
            Divider(height: 1),
            _PlayerRow(
              name: 'Dev Mehta',
              role: 'Middle order',
              runs: '318 runs',
              badge: 'WK',
            ),
            Divider(height: 1),
            _PlayerRow(
              name: 'Sameer Khan',
              role: 'Pace bowler',
              runs: '18 wickets',
              badge: 'B',
            ),
            Divider(height: 1),
            _PlayerRow(
              name: 'Nikhil Shah',
              role: 'All-rounder',
              runs: '245 runs',
              badge: 'AR',
            ),
          ],
        ),
      ),
    ],
  );
}

class _PlayerRow extends StatelessWidget {
  const _PlayerRow({
    required this.name,
    required this.role,
    required this.runs,
    required this.badge,
  });

  final String name;
  final String role;
  final String runs;
  final String badge;

  @override
  Widget build(BuildContext context) => ListTile(
    leading: CircleAvatar(
      backgroundColor: const Color(0xFFEAF4EE),
      child: Text(
        badge,
        style: const TextStyle(
          color: cricketGreen,
          fontWeight: FontWeight.w800,
          fontSize: 11,
        ),
      ),
    ),
    title: Text(
      name,
      style: const TextStyle(fontWeight: FontWeight.w800, color: cricketNavy),
    ),
    subtitle: Text(role, style: const TextStyle(fontSize: 11)),
    trailing: Text(
      runs,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        color: cricketGreen,
      ),
    ),
  );
}

class _ProfilePage extends StatelessWidget {
  const _ProfilePage();

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      Text(
        'Profile',
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w800,
          color: cricketNavy,
        ),
      ),
      const SizedBox(height: 4),
      const Text(
        'Your account, settings and match responsibilities.',
        style: TextStyle(color: Color(0xFF68766F)),
      ),
      const SizedBox(height: 16),
      Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 32,
                backgroundColor: Color(0xFFEAF4EE),
                child: Text(
                  'AR',
                  style: TextStyle(
                    color: cricketGreen,
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Alex Reynolds',
                      style: TextStyle(
                        color: cricketNavy,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Head scorer · Harbour XI',
                      style: TextStyle(color: Color(0xFF68766F), fontSize: 11),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.edit_outlined),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 18),
      const _SectionTitle('Quick stats', trailing: 'This season'),
      const SizedBox(height: 8),
      const Row(
        children: [
          Expanded(
            child: _QuickStat(
              label: 'Matches scored',
              value: '24',
              icon: Icons.sports_cricket_outlined,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: _QuickStat(
              label: 'Avg. score',
              value: '41',
              icon: Icons.bar_chart_outlined,
            ),
          ),
        ],
      ),
      const SizedBox(height: 18),
      const _SectionTitle('Preferences'),
      const SizedBox(height: 8),
      Card(
        child: Column(
          children: const [
            _SettingRow(
              icon: Icons.notifications_none,
              title: 'Match alerts',
              subtitle: 'Enabled for your club matches',
            ),
            Divider(height: 1),
            _SettingRow(
              icon: Icons.sync,
              title: 'Auto sync',
              subtitle: 'Wi-Fi only, every 15 minutes',
            ),
            Divider(height: 1),
            _SettingRow(
              icon: Icons.lock_outline,
              title: 'Data privacy',
              subtitle: 'Protected and local-first',
            ),
          ],
        ),
      ),
    ],
  );
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => ListTile(
    leading: CircleAvatar(
      backgroundColor: const Color(0xFFEAF4EE),
      child: Icon(icon, color: cricketGreen),
    ),
    title: Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.w700, color: cricketNavy),
    ),
    subtitle: Text(subtitle, style: const TextStyle(fontSize: 11)),
    trailing: const Icon(Icons.chevron_right),
  );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title, {this.trailing});
  final String title;
  final String? trailing;
  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: const TextStyle(
          color: cricketNavy,
          fontWeight: FontWeight.w800,
          fontSize: 14,
        ),
      ),
      if (trailing != null)
        Text(
          trailing!,
          style: const TextStyle(
            color: Color(0xFF68766F),
            fontSize: 9,
            fontWeight: FontWeight.w800,
            letterSpacing: .4,
          ),
        ),
    ],
  );
}

class _QuickStat extends StatelessWidget {
  const _QuickStat({
    required this.label,
    required this.value,
    required this.icon,
  });
  final String label;
  final String value;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Icon(icon, color: cricketGreen),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 19,
                    color: cricketNavy,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF68766F),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
