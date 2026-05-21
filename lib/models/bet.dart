class Bet {
  final String id;
  final String userId;
  final String userEmail;
  final String matchId;
  final int predictedTeam1Score;
  final int predictedTeam2Score;
  final DateTime timestamp;

  Bet({
    required this.id,
    required this.userId,
    required this.userEmail,
    required this.matchId,
    required this.predictedTeam1Score,
    required this.predictedTeam2Score,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'userEmail': userEmail,
        'matchId': matchId,
        'predictedTeam1Score': predictedTeam1Score,
        'predictedTeam2Score': predictedTeam2Score,
        'timestamp': timestamp.toIso8601String(),
      };

  factory Bet.fromJson(Map<String, dynamic> json) => Bet(
        id: json['id'] as String,
        userId: json['userId'] as String,
        userEmail: json['userEmail'] as String,
        matchId: json['matchId'] as String,
        predictedTeam1Score: json['predictedTeam1Score'] as int,
        predictedTeam2Score: json['predictedTeam2Score'] as int,
        timestamp: DateTime.parse(json['timestamp'] as String),
      );
}
