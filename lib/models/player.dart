class Player {
  final String id;
  final String name;
  final int number;
  final String teamId;

  Player({
    required this.id,
    required this.name,
    required this.number,
    required this.teamId,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'number': number,
        'teamId': teamId,
      };

  factory Player.fromJson(Map<String, dynamic> json) => Player(
        id: json['id'] as String,
        name: json['name'] as String,
        number: json['number'] as int,
        teamId: json['teamId'] as String,
      );
}
