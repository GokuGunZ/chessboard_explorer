import 'chess_exploration_session.dart';

class UserChessGames {
  final List<ChessExplorationSession> sessions;

  UserChessGames({required this.sessions});

  Map<String, dynamic> toJson() => {
    'sessions': sessions.map((s) => s.toJson()).toList(),
  };

  factory UserChessGames.fromJson(Map<String, dynamic> json) {
    return UserChessGames(
      sessions: (json['sessions'] as List)
          .map((e) => ChessExplorationSession.fromJson(e))
          .toList(),
    );
  }
}
