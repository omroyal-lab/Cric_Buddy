import 'package:flutter/foundation.dart';

import '../../data/demo_match.dart';

class BatterScore {
  BatterScore(DemoBatter batter)
    : name = batter.name,
      runs = batter.runs,
      balls = batter.balls,
      fours = batter.fours,
      sixes = batter.sixes;

  BatterScore._copy(BatterScore other)
    : name = other.name,
      runs = other.runs,
      balls = other.balls,
      fours = other.fours,
      sixes = other.sixes;

  final String name;
  int runs;
  int balls;
  int fours;
  int sixes;

  BatterScore copy() => BatterScore._copy(this);
}

class _ScoreSnapshot {
  const _ScoreSnapshot({
    required this.runs,
    required this.legalBalls,
    required this.strikerIndex,
    required this.batters,
    required this.currentOver,
  });

  final int runs;
  final int legalBalls;
  final int strikerIndex;
  final List<BatterScore> batters;
  final List<String> currentOver;
}

class ScoreSession extends ChangeNotifier {
  ScoreSession({DemoMatch match = demoMatch}) : _match = match {
    runs = match.score;
    wickets = match.wickets;
    legalBalls = match.legalBalls;
    strikerIndex = match.strikerIndex;
    batters = match.batters.map(BatterScore.new).toList();
    currentOver = [...match.currentOver];
  }

  final DemoMatch _match;
  late int runs;
  late int wickets;
  late int legalBalls;
  late int strikerIndex;
  late List<BatterScore> batters;
  late List<String> currentOver;
  final List<_ScoreSnapshot> _history = [];

  DemoMatch get match => _match;
  bool get canUndo => _history.isNotEmpty;
  BatterScore get striker => batters[strikerIndex];
  BatterScore get nonStriker => batters[1 - strikerIndex];
  int get runsNeeded => (_match.target - runs).clamp(0, _match.target);
  int get ballsRemaining =>
      (_match.oversLimit * 6 - legalBalls).clamp(0, _match.oversLimit * 6);
  double get currentRunRate => legalBalls == 0 ? 0 : runs * 6 / legalBalls;
  double get requiredRunRate =>
      ballsRemaining == 0 ? 0 : runsNeeded * 6 / ballsRemaining;
  String get overs => '${legalBalls ~/ 6}.${legalBalls % 6}';

  void recordRuns(int batterRuns) {
    if (batterRuns < 0 || runsNeeded == 0 || ballsRemaining == 0) return;
    _history.add(_snapshot());
    final batter = striker;
    runs += batterRuns;
    batter.runs += batterRuns;
    batter.balls += 1;
    if (batterRuns == 4) batter.fours += 1;
    if (batterRuns == 6) batter.sixes += 1;
    legalBalls += 1;
    currentOver.add(batterRuns == 0 ? '•' : '$batterRuns');
    if (batterRuns.isOdd) strikerIndex = 1 - strikerIndex;
    if (legalBalls % 6 == 0) {
      strikerIndex = 1 - strikerIndex;
      currentOver = [];
    }
    notifyListeners();
  }

  void undo() {
    if (_history.isEmpty) return;
    final snapshot = _history.removeLast();
    runs = snapshot.runs;
    legalBalls = snapshot.legalBalls;
    strikerIndex = snapshot.strikerIndex;
    batters = snapshot.batters.map((batter) => batter.copy()).toList();
    currentOver = [...snapshot.currentOver];
    notifyListeners();
  }

  _ScoreSnapshot _snapshot() => _ScoreSnapshot(
    runs: runs,
    legalBalls: legalBalls,
    strikerIndex: strikerIndex,
    batters: batters.map((batter) => batter.copy()).toList(),
    currentOver: [...currentOver],
  );
}
