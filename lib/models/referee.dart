class Referee {
  final String id;
  final String name;

  Referee({required this.id, required this.name});

  Map<String, dynamic> toJson() => {'id': id, 'name': name};

  factory Referee.fromJson(Map<String, dynamic> json) =>
      Referee(id: json['id'] as String, name: json['name'] as String);
}
