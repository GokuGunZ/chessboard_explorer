import 'package:chessboard_explorer/models/user_graph_data.dart';
import 'package:hive/hive.dart';

part 'user_data.g.dart';

@HiveType(typeId: 2)
class UserData {
  @HiveField(0)
  UserGraphData userGraphData;

  @HiveField(1)
  List<String> preferredExplorations; // ids delle esplorazioni preferite

  UserData({
    required this.userGraphData,
    this.preferredExplorations = const [],
  });

  UserData copyWith({
    UserGraphData? userGraph,
    List<String>? preferredExplorations,
  }) {
    return UserData(
      userGraphData: userGraph ?? userGraphData,
      preferredExplorations:
          preferredExplorations ?? this.preferredExplorations,
    );
  }

  UserData updateWith({
    UserGraphData? userGraphData,
    List<String>? preferredExplorations,
  }) {
    this.userGraphData = userGraphData ?? this.userGraphData;
    this.preferredExplorations =
        preferredExplorations ?? this.preferredExplorations;
    return this;
  }

  Map<String, dynamic> toJson() => {
    'userGraph': userGraphData.toJson(),
    'preferredExplorations': preferredExplorations,
  };

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    userGraphData: UserGraphData.fromJson(json['userGraph']),
    preferredExplorations: List<String>.from(
      json['preferredExplorations'] ?? [],
    ),
  );
}
