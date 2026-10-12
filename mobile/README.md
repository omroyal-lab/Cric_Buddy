# CricScore Flutter app

This is the native Flutter workspace for Android and iOS. Run it from this directory with `flutter run`.

The first vertical slice includes the five-tab application shell and a live scoring screen. Sample match details live in `lib/data/demo_match.dart`; normal-run entry and undo are isolated in `lib/domain/scoring/score_session.dart` and exist only in memory.

This is not a production scoring system yet. Extras and wicket flows are UI entry points only; cricket-law handling, persistence, SQLite/offline recovery, authentication, REST APIs, WebSocket synchronization, and complete tournament/team workflows still need implementation. Demo data is not live match data.
