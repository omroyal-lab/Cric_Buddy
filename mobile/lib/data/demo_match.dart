class DemoBatter {
  const DemoBatter({
    required this.name,
    required this.runs,
    required this.balls,
    required this.fours,
    required this.sixes,
  });

  final String name;
  final int runs;
  final int balls;
  final int fours;
  final int sixes;
}

class DemoMatch {
  const DemoMatch({
    required this.homeTeam,
    required this.awayTeam,
    required this.venue,
    required this.score,
    required this.wickets,
    required this.legalBalls,
    required this.target,
    required this.oversLimit,
    required this.batters,
    required this.strikerIndex,
    required this.bowler,
    required this.bowlerFigures,
    required this.completedOver,
    required this.currentOver,
  });

  final String homeTeam;
  final String awayTeam;
  final String venue;
  final int score;
  final int wickets;
  final int legalBalls;
  final int target;
  final int oversLimit;
  final List<DemoBatter> batters;
  final int strikerIndex;
  final String bowler;
  final String bowlerFigures;
  final List<String> completedOver;
  final List<String> currentOver;
}

const demoMatch = DemoMatch(
  homeTeam: 'Harbour XI',
  awayTeam: 'Riverside CC',
  venue: 'Oval Community Ground',
  score: 126,
  wickets: 4,
  legalBalls: 86,
  target: 171,
  oversLimit: 20,
  batters: [
    DemoBatter(name: 'Arjun Rao', runs: 48, balls: 31, fours: 5, sixes: 2),
    DemoBatter(name: 'Dev Mehta', runs: 19, balls: 15, fours: 2, sixes: 0),
  ],
  strikerIndex: 0,
  bowler: 'Samir Khan',
  bowlerFigures: '3.2 - 0 - 28 - 1',
  completedOver: ['1', '4', '0', '2', 'W', '1'],
  currentOver: ['1', '•'],
);
