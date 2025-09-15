// session.dart
import 'package:chessboard_explorer/domain/enum/session_mode.dart';

class Session {
  String currentNodeId;
  SessionMode mode;
  List<String> history;
  List<String> moveStack;

  Session({
    required this.currentNodeId,
    this.mode = SessionMode.discover,
    this.history = const [],
    this.moveStack = const [],
  });

  Map<String, dynamic> toJson() => {
    'currentNodeId': currentNodeId,
    'mode': mode.toString(),
    'history': history,
    'moveStack': moveStack,
  };

  factory Session.fromJson(Map<String, dynamic> json) => Session(
    currentNodeId: json['currentNodeId'],
    mode: SessionMode.values.firstWhere(
      (m) => m.toString() == json['mode'],
      orElse: () => SessionMode.discover,
    ),
    history: List<String>.from(json['history'] ?? []),
    moveStack: List<String>.from(json['moveStack'] ?? []),
  );
}
