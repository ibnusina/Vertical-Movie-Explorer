import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:imdb_vertical/data/movie.dart';
import 'package:imdb_vertical/data/movie_service.dart';
import 'package:imdb_vertical/features/movie_detail/movie_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController _pageController = PageController();
  List<Movie> movies = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadMovies();
  }

  Future<void> loadMovies() async {
    final fetchedMovies = await MovieService.getPopularMovies();
    setState(() {
      movies = fetchedMovies;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: movies.length,
        itemBuilder: (context, index) {
          return MovieBoardView(
            movie: movies[index],
            onMovieInfoTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovieDetailScreen(movie: movies[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

// Video Player Screen Component
class MovieBoardView extends StatefulWidget {
  final Movie movie;
  final VoidCallback onMovieInfoTap;

  const MovieBoardView({
    Key? key,
    required this.movie,
    required this.onMovieInfoTap,
  }) : super(key: key);

  @override
  _MovieBoardViewState createState() => _MovieBoardViewState();
}

class _MovieBoardViewState extends State<MovieBoardView> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Video/Image placeholder (since we need actual video URLs from TMDB API)
        Container(
          width: double.infinity,
          height: double.infinity,
          child:
              widget.movie.backdropPath.isNotEmpty
                  ? CachedNetworkImage(
                    imageUrl: MovieService.getImageUrl(
                      widget.movie.backdropPath,
                    ),
                    fit: BoxFit.cover,
                    placeholder:
                        (context, url) =>
                            Center(child: CircularProgressIndicator()),
                    errorWidget:
                        (context, url, error) => Container(
                          color: Colors.grey[800],
                          child: Icon(
                            Icons.error,
                            color: Colors.white,
                            size: 50,
                          ),
                        ),
                  )
                  : Container(
                    color: Colors.grey[800],
                    child: Center(
                      child: Icon(Icons.movie, color: Colors.white, size: 100),
                    ),
                  ),
        ),

        // Gradient overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.transparent,
                Colors.black.withOpacity(0.7),
              ],
            ),
          ),
        ),

        // Movie info button
        Positioned(
          top: MediaQuery.of(context).padding.top + 20,
          right: 20,
          child: GestureDetector(
            onTap: widget.onMovieInfoTap,
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.white, size: 24),
                  SizedBox(width: 8),
                  Text("View Movie", style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
        ),

        // Bottom content
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.movie.title,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    SizedBox(width: 4),
                    Text(
                      widget.movie.voteAverage.toStringAsFixed(1),
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    SizedBox(width: 16),
                    Text(
                      widget.movie.releaseDate.split('-')[0],
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  child: Text(
                    widget.movie.overview,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      height: 1.4,
                    ),
                    maxLines: isExpanded ? null : 2,
                    overflow: isExpanded ? null : TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
