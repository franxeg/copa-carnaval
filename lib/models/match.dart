class Goal {
  final String id;
  final String playerId;
  final String playerName;
  final String teamId;
  final int minute;
  final bool isOwnGoal;

  Goal({
    required this.id,
    required this.playerId,
    required this.playerName,
    required this.teamId,
    required this.minute,
    this.isOwnGoal = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'playerId': playerId,
        'playerName': playerName,
        'teamId': teamId,
        'minute': minute,
        'isOwnGoal': isOwnGoal,
      };

  factory Goal.fromJson(Map<String, dynamic> json) => Goal(
        id: json['id'] as String,
        playerId: json['playerId'] as String,
        playerName: json['playerName'] as String,
        teamId: json['teamId'] as String,
        minute: json['minute'] as int,
        isOwnGoal: json['isOwnGoal'] as bool? ?? false,
      );
}

class MatchCard {
  final String id;
  final String playerId;
  final String playerName;
  final String teamId;
  final int minute;
  final String type;

  MatchCard({
    required this.id,
    required this.playerId,
    required this.playerName,
    required this.teamId,
    required this.minute,
    required this.type,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'playerId': playerId,
        'playerName': playerName,
        'teamId': teamId,
        'minute': minute,
        'type': type,
      };

  factory MatchCard.fromJson(Map<String, dynamic> json) => MatchCard(
        id: json['id'] as String,
        playerId: json['playerId'] as String,
        playerName: json['playerName'] as String,
        teamId: json['teamId'] as String,
        minute: json['minute'] as int,
        type: json['type'] as String,
      );
}

class Match {
  final String id;
  final String round;
  final String? groupName;
  final String team1Id;
  final String team1Name;
  final String team2Id;
  final String team2Name;
  final DateTime dateTime;
  final String? refereeId;
  final String? refereeName;
  final String status;
  final int? team1Score;
  final int? team2Score;
  final List<Goal> goals;
  final List<MatchCard> cards;
  final int dayNumber;

  Match({
    required this.id,
    required this.round,
    this.groupName,
    required this.team1Id,
    required this.team1Name,
    required this.team2Id,
    required this.team2Name,
    required this.dateTime,
    this.refereeId,
    this.refereeName,
    this.status = 'scheduled',
    this.team1Score,
    this.team2Score,
    this.goals = const [],
    this.cards = const [],
    required this.dayNumber,
  });

  Match copyWith({
    String? status,
    int? team1Score,
    int? team2Score,
    List<Goal>? goals,
    List<MatchCard>? cards,
    String? refereeId,
    String? refereeName,
  }) {
    return Match(
      id: id,
      round: round,
      groupName: groupName,
      team1Id: team1Id,
      team1Name: team1Name,
      team2Id: team2Id,
      team2Name: team2Name,
      dateTime: dateTime,
      refereeId: refereeId ?? this.refereeId,
      refereeName: refereeName ?? this.refereeName,
      status: status ?? this.status,
      team1Score: team1Score ?? this.team1Score,
      team2Score: team2Score ?? this.team2Score,
      goals: goals ?? this.goals,
      cards: cards ?? this.cards,
      dayNumber: dayNumber,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'round': round,
        'groupName': groupName,
        'team1Id': team1Id,
        'team1Name': team1Name,
        'team2Id': team2Id,
        'team2Name': team2Name,
        'dateTime': dateTime.toIso8601String(),
        'refereeId': refereeId,
        'refereeName': refereeName,
        'status': status,
        'team1Score': team1Score,
        'team2Score': team2Score,
        'goals': goals.map((g) => g.toJson()).toList(),
        'cards': cards.map((c) => c.toJson()).toList(),
        'dayNumber': dayNumber,
      };

  factory Match.fromJson(Map<String, dynamic> json) => Match(
        id: json['id'] as String,
        round: json['round'] as String,
        groupName: json['groupName'] as String?,
        team1Id: json['team1Id'] as String,
        team1Name: json['team1Name'] as String,
        team2Id: json['team2Id'] as String,
        team2Name: json['team2Name'] as String,
        dateTime: DateTime.parse(json['dateTime'] as String),
        refereeId: json['refereeId'] as String?,
        refereeName: json['refereeName'] as String?,
        status: json['status'] as String? ?? 'scheduled',
        team1Score: json['team1Score'] as int?,
        team2Score: json['team2Score'] as int?,
        goals: (json['goals'] as List<dynamic>?)
                ?.map((g) => Goal.fromJson(g as Map<String, dynamic>))
                .toList() ??
            [],
        cards: (json['cards'] as List<dynamic>?)
                ?.map((c) => MatchCard.fromJson(c as Map<String, dynamic>))
                .toList() ??
            [],
        dayNumber: json['dayNumber'] as int,
      );
}
