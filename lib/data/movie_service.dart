import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:imdb_vertical/data/actor.dart';
import 'package:imdb_vertical/data/cast.dart';
import 'package:imdb_vertical/data/movie.dart';

class MovieService {
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';
  static const String apiKey =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJkMjU5OTBjZDQ4MDNhZjU0ZDgyNmY0MjM0NWFlNTFkNiIsIm5iZiI6MTc1Nzc0NzcyMi40MTUsInN1YiI6IjY4YzUxYTBhN2I2ZGU1NDEwZWFjYWIzYiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.ELw1sWNe6WsnU9dDivhfan1sM-ojn6YAEGO4b78lDds'; // Replace with your actual API key

  static Future<List<Movie>> getPopularMovies() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/movie/popular'),
        headers: {'Authorization': 'Bearer $apiKey'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        return results.map((json) => Movie.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching movies: $e');
      return [];
    }
  }

  static Future<List<Cast>> getMovieCast(String movieId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/movie/$movieId/credits'),
        headers: {'Authorization': 'Bearer $apiKey'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> cast = data['cast'];
        return cast.take(10).map((json) => Cast.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching cast: $e');
      return [];
    }
  }

  static Future<Actor> getActorDetails(String actorId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/person/$actorId'),
        headers: {'Authorization': 'Bearer $apiKey'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Actor.fromJson(data);
      }
      throw Exception('Failed to load actor details');
    } catch (e) {
      print('Error fetching actor: $e');
      rethrow;
    }
  }

  static Future<List<Movie>> getActorMovies(String actorId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/person/$actorId/movie_credits'),
        headers: {'Authorization': 'Bearer $apiKey'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> cast = data['cast'];
        return cast.map((json) => Movie.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching actor movies: $e');
      return [];
    }
  }

  static String getImageUrl(String path) {
    return path.isNotEmpty ? '$imageBaseUrl$path' : '';
  }
}
