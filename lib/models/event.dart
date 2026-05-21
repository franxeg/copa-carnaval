class Event {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String? location;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    this.location,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'date': date.toIso8601String(),
        'location': location,
      };

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        date: DateTime.parse(json['date'] as String),
        location: json['location'] as String?,
      );
}
