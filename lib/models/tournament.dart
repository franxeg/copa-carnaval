class Tournament {
  final String id;
  final String name;
  final String city;
  final DateTime startDate;
  final DateTime endDate;
  final List<String> groupNames;

  Tournament({
    required this.id,
    required this.name,
    required this.city,
    required this.startDate,
    required this.endDate,
    this.groupNames = const ['A', 'B', 'C', 'D'],
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'city': city,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'groupNames': groupNames,
      };

  factory Tournament.fromJson(Map<String, dynamic> json) => Tournament(
        id: json['id'] as String,
        name: json['name'] as String,
        city: json['city'] as String,
        startDate: DateTime.parse(json['startDate'] as String),
        endDate: DateTime.parse(json['endDate'] as String),
        groupNames: (json['groupNames'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            ['A', 'B', 'C', 'D'],
      );
}
