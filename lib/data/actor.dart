import 'package:imdb_vertical/data/movie.dart';

class Actor {
  final String id;
  final String name;
  final String biography;
  final String profilePath;
  final String birthday;
  final String placeOfBirth;
  final List<Movie> movies;

  Actor({
    required this.id,
    required this.name,
    required this.biography,
    required this.profilePath,
    required this.birthday,
    required this.placeOfBirth,
    required this.movies,
  });

  factory Actor.fromJson(Map<String, dynamic> json) {
    return Actor(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      biography: json['biography'] ?? '',
      profilePath: json['profile_path'] ?? '',
      birthday: json['birthday'] ?? '',
      placeOfBirth: json['place_of_birth'] ?? '',
      movies: [],
    );
  }
}
