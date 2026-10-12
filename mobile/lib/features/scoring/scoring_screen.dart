import 'package:flutter/material.dart';

import '../../domain/scoring/score_session.dart';
import '../../theme/app_colors.dart';

class ScoringScreen extends StatelessWidget {
  const ScoringScreen({super.key, required this.session});
  final ScoreSession session;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Expanded(
        child: AnimatedBuilder(
          animation: session,
          builder: (context, _) => ListView(
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 8),
            children: [
              const _StatusBanner(),
              const SizedBox(height: 7),
              _ScoreCard(session: session),
              const SizedBox(height: 7),
              _HeaderRow(
                'At the crease',
                TextButton(
                  onPressed: () => _showScorecard(context, session),
                  child: const Text('Scorecard'),
                ),
              ),
              _BatterPanel(session: session),
              const SizedBox(height: 7),
              _HeaderRow(
                'Current over',
                Text(
                  'Over ${session.legalBalls ~/ 6 + 1} · ${session.legalBalls % 6}/6 balls',
                ),
              ),
              _OverPanel(session: session),
            ],
          ),
        ),
      ),
      AnimatedBuilder(
        animation: session,
        builder: (context, _) => _RunControls(session: session),
      ),
    ],
  );
}

class _StatusBanner extends StatelessWidget {
  const _StatusBanner();
  @override
  Widget build(BuildContext context) => Container(
    height: 31,
    padding: const EdgeInsets.symmetric(horizontal: 9),
    decoration: BoxDecoration(
      color: const Color(0xFFFFF7E5),
      border: Border.all(color: const Color(0xFFEAD6A8)),
      borderRadius: BorderRadius.circular(9),
    ),
    child: const Row(
      children: [
        Icon(Icons.cloud_off_outlined, size: 14, color: Color(0xFF8A5B07)),
        SizedBox(width: 6),
        Expanded(
          child: Text(
            'Local session · not synced',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Color(0xFF74500F),
            ),
          ),
        ),
        Text(
          'SAMPLE',
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w800,
            color: Color(0xFF8A5B07),
          ),
        ),
      ],
    ),
  );
}

class _ScoreCard extends StatelessWidget {
  const _ScoreCard({required this.session});
  final ScoreSession session;
  @override
  Widget build(BuildContext context) {
    final match = session.match;
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: cricketGreen,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '2ND INNINGS · ${match.homeTeam.toUpperCase()} BATTING',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${match.homeTeam} vs ${match.awayTeam}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      match.venue,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .14),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: .32),
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.circle, size: 6, color: Color(0xFFCBF2D4)),
                    SizedBox(width: 5),
                    Text(
                      'LIVE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            '${session.runs}/${session.wickets}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 48,
              height: 1,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            '${session.overs} overs · CRR ${session.currentRunRate.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 7),
          const Divider(color: Color(0x55FFFFFF), height: 1),
          const SizedBox(height: 6),
          Text(
            'Target ${match.target} · ${session.runsNeeded} needed from ${session.ballsRemaining} balls · RRR ${session.requiredRunRate.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow(this.title, this.trailing);
  final String title;
  final Widget trailing;
  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: const TextStyle(
          color: cricketNavy,
          fontSize: 13,
          fontWeight: FontWeight.w800,
        ),
      ),
      DefaultTextStyle(
        style: const TextStyle(color: Color(0xFF68766F), fontSize: 10),
        child: trailing,
      ),
    ],
  );
}

class _BatterPanel extends StatelessWidget {
  const _BatterPanel({required this.session});
  final ScoreSession session;
  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.zero,
    child: Column(
      children: [
        _BatterRow(session.striker, true),
        const Divider(height: 1),
        _BatterRow(session.nonStriker, false),
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Row(
            children: [
              const Icon(
                Icons.sports_cricket_outlined,
                size: 14,
                color: Color(0xFF68766F),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  session.match.bowler,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                session.match.bowlerFigures,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _BatterRow extends StatelessWidget {
  const _BatterRow(this.batter, this.striker);
  final BatterScore batter;
  final bool striker;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
    child: Row(
      children: [
        CircleAvatar(
          radius: 13,
          backgroundColor: const Color(0xFFEAF2EC),
          child: Text(
            batter.name.substring(0, 1),
            style: const TextStyle(
              color: cricketGreen,
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            '${batter.name}${striker ? '  •' : ''}',
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: cricketNavy,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Text(
          '${batter.runs} (${batter.balls})',
          style: const TextStyle(
            color: cricketNavy,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(width: 7),
        Text(
          '4s ${batter.fours} · 6s ${batter.sixes}',
          style: const TextStyle(color: Color(0xFF68766F), fontSize: 9),
        ),
      ],
    ),
  );
}

class _OverPanel extends StatelessWidget {
  const _OverPanel({required this.session});
  final ScoreSession session;
  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.zero,
    child: Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                session.match.bowler,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Last: ${session.match.completedOver.join(' · ')}',
                  textAlign: TextAlign.end,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 9, color: Color(0xFF68766F)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              for (var index = 0; index < 6; index++) ...[
                if (index != 0) const SizedBox(width: 6),
                Expanded(
                  child: _Ball(
                    value: index < session.currentOver.length
                        ? session.currentOver[index]
                        : '·',
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    ),
  );
}

class _Ball extends StatelessWidget {
  const _Ball({required this.value});
  final String value;
  @override
  Widget build(BuildContext context) {
    final wicket = value == 'W';
    final boundary = value == '4' || value == '6';
    final color = wicket
        ? const Color(0xFFB33332)
        : boundary
        ? cricketGreen
        : const Color(0xFF526159);
    final fill = wicket
        ? const Color(0xFFFCEBEA)
        : boundary
        ? const Color(0xFFE5F3E9)
        : const Color(0xFFF1F5F2);
    return Container(
      height: 29,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: fill,
        border: Border.all(color: color.withValues(alpha: .17)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        value,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _RunControls extends StatelessWidget {
  const _RunControls({required this.session});
  final ScoreSession session;
  @override
  Widget build(BuildContext context) => SafeArea(
    top: false,
    child: Container(
      padding: const EdgeInsets.fromLTRB(9, 7, 9, 7),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: lineColor)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              for (final runs in [0, 1, 2, 3, 4, 6]) ...[
                if (runs > 0) const SizedBox(width: 5),
                Expanded(
                  child: SizedBox(
                    height: 49,
                    child: FilledButton(
                      key: ValueKey('run-$runs'),
                      onPressed:
                          session.runsNeeded == 0 || session.ballsRemaining == 0
                          ? null
                          : () => session.recordRuns(runs),
                      style: FilledButton.styleFrom(
                        backgroundColor: runs >= 4
                            ? const Color(0xFFE7F2E9)
                            : const Color(0xFFF4F8F5),
                        foregroundColor: cricketGreen,
                        elevation: 0,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(color: Color(0xFFD8E5DB)),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      child: Text('$runs'),
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 7),
          Row(
            children: [
              Expanded(
                child: _ControlButton(
                  'Extras',
                  Icons.add_circle_outline,
                  const Color(0xFF80580D),
                  () => _showExtras(context),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _ControlButton(
                  'Wicket',
                  Icons.sports_cricket,
                  const Color(0xFFAE3432),
                  () => _showWicket(context),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _ControlButton(
                  'Undo',
                  Icons.undo,
                  const Color(0xFF526159),
                  session.canUndo ? () => _undo(context, session) : null,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class _ControlButton extends StatelessWidget {
  const _ControlButton(this.label, this.icon, this.color, this.action);
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? action;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 48,
    child: OutlinedButton.icon(
      onPressed: action,
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: color.withValues(alpha: .2)),
        padding: const EdgeInsets.symmetric(horizontal: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800),
      ),
    ),
  );
}

Future<void> _showExtras(BuildContext context) async {
  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ListTile(
            title: Text(
              'Add extras',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            subtitle: Text('Choose delivery type'),
          ),
          for (final label in [
            'Wide',
            'No-ball',
            'Bye',
            'Leg-bye',
            'Penalty runs',
          ])
            ListTile(
              leading: const Icon(
                Icons.add_circle_outline,
                color: cricketGreen,
              ),
              title: Text(label),
              onTap: () {
                Navigator.pop(context);
                _notice(
                  context,
                  '$label needs match-rules integration. Nothing changed.',
                );
              },
            ),
          const SizedBox(height: 8),
        ],
      ),
    ),
  );
}

Future<void> _showWicket(BuildContext context) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ListTile(
              title: Text(
                'Record wicket',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              subtitle: Text('Dismissal details'),
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Dismissal type',
                border: OutlineInputBorder(),
              ),
              items:
                  const [
                        'Bowled',
                        'Caught',
                        'Run out',
                        'LBW',
                        'Stumped',
                        'Hit wicket',
                      ]
                      .map(
                        (type) =>
                            DropdownMenuItem(value: type, child: Text(type)),
                      )
                      .toList(),
              onChanged: (_) {},
            ),
            const SizedBox(height: 10),
            const Text(
              'Dismissed batter: current striker',
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                _notice(
                  context,
                  'Wicket UI only. Dismissal rules are not connected.',
                );
              },
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    ),
  );
}

Future<void> _undo(BuildContext context, ScoreSession session) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Undo last delivery?'),
      content: const Text('Remove the last local run entry?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Undo'),
        ),
      ],
    ),
  );
  if (confirmed == true) session.undo();
}

void _notice(BuildContext context, String message) => ScaffoldMessenger.of(
  context,
).showSnackBar(SnackBar(content: Text(message)));

Future<void> _showScorecard(BuildContext context, ScoreSession session) async {
  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(
              '${session.match.homeTeam} · ${session.runs}/${session.wickets}',
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
          for (final batter in session.batters)
            ListTile(
              title: Text(batter.name),
              trailing: Text('${batter.runs} (${batter.balls})'),
            ),
          const ListTile(
            title: Text(
              'Full scorecard and extras are not connected yet.',
              style: TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    ),
  );
}
