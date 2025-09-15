import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:imdb_vertical/data/cast.dart';
import 'package:imdb_vertical/data/movie.dart';
import 'package:imdb_vertical/data/movie_service.dart';
import 'package:imdb_vertical/features/actor_detail/actor_detail_screen.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailScreen({Key? key, required this.movie}) : super(key: key);

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  List<Cast> cast = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadMovieDetails();
  }

  Future<void> loadMovieDetails() async {
    final movieCast = await MovieService.getMovieCast(widget.movie.id);
    setState(() {
      cast = movieCast;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Movie Poster
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background:
                  widget.movie.posterPath.isNotEmpty
                      ? CachedNetworkImage(
                        imageUrl: MovieService.getImageUrl(
                          widget.movie.posterPath,
                        ),
                        fit: BoxFit.cover,
                      )
                      : Container(
                        color: Colors.grey[800],
                        child: Icon(
                          Icons.movie,
                          size: 100,
                          color: Colors.white,
                        ),
                      ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Movie Title and Info
                  Text(
                    widget.movie.title,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 20),
                      SizedBox(width: 4),
                      Text(
                        widget.movie.voteAverage.toStringAsFixed(1),
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(width: 16),
                      Text(
                        widget.movie.releaseDate,
                        style: TextStyle(fontSize: 16, color: Colors.grey[400]),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),

                  // Cast Section
                  Text(
                    'Cast',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  isLoading
                      ? Center(child: CircularProgressIndicator())
                      : Container(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: cast.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => ActorDetailScreen(
                                          actorId: cast[index].id,
                                        ),
                                  ),
                                );
                              },
                              child: Container(
                                width: 80,
                                margin: EdgeInsets.only(right: 12),
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundImage:
                                          cast[index].profilePath.isNotEmpty
                                              ? CachedNetworkImageProvider(
                                                MovieService.getImageUrl(
                                                  cast[index].profilePath,
                                                ),
                                              )
                                              : null,
                                      child:
                                          cast[index].profilePath.isEmpty
                                              ? Icon(Icons.person, size: 30)
                                              : null,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      cast[index].name,
                                      style: TextStyle(fontSize: 12),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  SizedBox(height: 24),

                  // Description Section
                  Text(
                    'Description',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  Text(
                    widget.movie.overview,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Colors.grey[300],
                    ),
                  ),

                  SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
