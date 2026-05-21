class Team {
  final String id;
  final String name;
  final String? logoUrl;
  final String groupName;

  Team({
    required this.id,
    required this.name,
    this.logoUrl,
    required this.groupName,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'logoUrl': logoUrl,
        'groupName': groupName,
      };

  factory Team.fromJson(Map<String, dynamic> json) => Team(
        id: json['id'] as String,
        name: json['name'] as String,
        logoUrl: json['logoUrl'] as String?,
        groupName: json['groupName'] as String,
      );
}
