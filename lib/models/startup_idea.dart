import 'package:equatable/equatable.dart';

class StartupIdea extends Equatable {
  final String id;
  final String name;
  final String tagline;
  final String description;
  final int aiRating;
  final int votes;
  final DateTime createdAt;

  const StartupIdea({
    required this.id,
    required this.name,
    required this.tagline,
    required this.description,
    required this.aiRating,
    this.votes = 0,
    required this.createdAt,
  });

  StartupIdea copyWith({
    String? id,
    String? name,
    String? tagline,
    String? description,
    int? aiRating,
    int? votes,
    DateTime? createdAt,
  }) {
    return StartupIdea(
      id: id ?? this.id,
      name: name ?? this.name,
      tagline: tagline ?? this.tagline,
      description: description ?? this.description,
      aiRating: aiRating ?? this.aiRating,
      votes: votes ?? this.votes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'tagline': tagline,
      'description': description,
      'aiRating': aiRating,
      'votes': votes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory StartupIdea.fromJson(Map<String, dynamic> json) {
    return StartupIdea(
      id: json['id'],
      name: json['name'],
      tagline: json['tagline'],
      description: json['description'],
      aiRating: json['aiRating'],
      votes: json['votes'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    tagline,
    description,
    aiRating,
    votes,
    createdAt,
  ];
}
