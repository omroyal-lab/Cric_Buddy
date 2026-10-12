// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cric_score/app.dart';
import 'package:cric_score/domain/scoring/score_session.dart';

void main() {
  testWidgets('run entry updates the score and can be undone', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const CricScoreApp());
    final nav = tester.widget<NavigationBar>(find.byType(NavigationBar));

    nav.onDestinationSelected?.call(1);
    await tester.pumpAndSettle();
    expect(find.text('126/4'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('run-4')));
    await tester.pump();
    expect(find.text('130/4'), findsOneWidget);

    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Undo').last);
    await tester.pumpAndSettle();
    expect(find.text('126/4'), findsOneWidget);
  });

  testWidgets('tournaments and teams screens show real product content', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const CricScoreApp());
    final nav = tester.widget<NavigationBar>(find.byType(NavigationBar));

    nav.onDestinationSelected?.call(2);
    await tester.pumpAndSettle();
    await tester.dragUntilVisible(
      find.text('Season ladder'),
      find.byType(ListView),
      const Offset(0, -200),
    );
    await tester.pumpAndSettle();
    expect(find.text('Season ladder'), findsOneWidget);

    nav.onDestinationSelected?.call(3);
    await tester.pumpAndSettle();
    await tester.dragUntilVisible(
      find.text('My teams'),
      find.byType(ListView),
      const Offset(0, -200),
    );
    await tester.pumpAndSettle();
    expect(find.text('My teams'), findsOneWidget);
  });

  testWidgets('tournament result entry publishes a result summary', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const CricScoreApp());
    final nav = tester.widget<NavigationBar>(find.byType(NavigationBar));

    nav.onDestinationSelected?.call(2);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Result entry'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Harbour XI won by 7 wickets'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Publish result'));
    await tester.pumpAndSettle();

    expect(find.text('Result published to the league table'), findsOneWidget);
  });

  testWidgets('published result appears as a tournament summary banner', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const CricScoreApp());
    final nav = tester.widget<NavigationBar>(find.byType(NavigationBar));

    nav.onDestinationSelected?.call(2);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Result entry'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Harbour XI won by 7 wickets'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Publish result'));
    await tester.pumpAndSettle();

    expect(
      find.text('Latest result: Harbour XI won by 7 wickets'),
      findsOneWidget,
    );
  });

  testWidgets('fixture board shows live match-day status', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const CricScoreApp());
    final nav = tester.widget<NavigationBar>(find.byType(NavigationBar));

    nav.onDestinationSelected?.call(2);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Fixture board'));
    await tester.pumpAndSettle();

    expect(find.text('Match-day board'), findsOneWidget);
    expect(find.text('Harbour XI vs East End CC'), findsOneWidget);
  });

  testWidgets('home screen opens the match centre overview', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const CricScoreApp());
    final nav = tester.widget<NavigationBar>(find.byType(NavigationBar));

    nav.onDestinationSelected?.call(0);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Open match centre'));
    await tester.pumpAndSettle();

    expect(find.text('Match centre'), findsOneWidget);
  });

  testWidgets('saved matches section is visible on the home dashboard', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const CricScoreApp());
    await tester.pumpAndSettle();

    await tester.dragUntilVisible(
      find.text('Saved matches'),
      find.byType(ListView),
      const Offset(0, -200),
    );
    await tester.pumpAndSettle();

    expect(find.text('Saved matches'), findsOneWidget);
    expect(find.text('Harbour XI vs Riverside CC'), findsOneWidget);
  });

  testWidgets('saved match can open the live scoring tab from the dashboard', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const CricScoreApp());
    final nav = tester.widget<NavigationBar>(find.byType(NavigationBar));

    nav.onDestinationSelected?.call(0);
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey('quick-open-saved-match')),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const ValueKey('quick-open-saved-match')));
    await tester.pumpAndSettle();

    expect(find.textContaining('2ND INNINGS'), findsOneWidget);
  });

  testWidgets('create match flow keeps the selected format and venue', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const CricScoreApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Create new match'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Northbank Oval');
    await tester.tap(find.text('Start live scoring'));
    await tester.pumpAndSettle();

    expect(find.text('Northbank Oval · T20'), findsOneWidget);
  });

  test('undo restores score, striker, and legal-ball count', () {
    final session = ScoreSession();
    session.recordRuns(1);
    expect(session.runs, 127);
    expect(session.legalBalls, 87);
    expect(session.striker.name, 'Dev Mehta');

    session.undo();
    expect(session.runs, 126);
    expect(session.legalBalls, 86);
    expect(session.striker.name, 'Arjun Rao');
    expect(session.striker.runs, 48);
    session.dispose();
  });
}
