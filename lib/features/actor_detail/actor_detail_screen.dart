import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:imdb_vertical/data/actor.dart';
import 'package:imdb_vertical/data/movie.dart';
import 'package:imdb_vertical/data/movie_service.dart';
import 'package:imdb_vertical/features/movie_detail/movie_detail_screen.dart';

class ActorDetailScreen extends StatefulWidget {
  final String actorId;

  const ActorDetailScreen({Key? key, required this.actorId}) : super(key: key);

  @override
  _ActorDetailScreenState createState() => _ActorDetailScreenState();
}

class _ActorDetailScreenState extends State<ActorDetailScreen> {
  Actor? actor;
  List<Movie> actorMovies = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadActorDetails();
  }

  Future<void> loadActorDetails() async {
    try {
      final actorDetails = await MovieService.getActorDetails(widget.actorId);
      final movies = await MovieService.getActorMovies(widget.actorId);

      setState(() {
        actor = actorDetails;
        actorMovies = movies;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (actor == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Error')),
        body: Center(child: Text('Failed to load actor details')),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Actor Photo
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                actor!.name,
                style: TextStyle(
                  shadows: [
                    Shadow(
                      color: Colors.black,
                      offset: Offset(1, 1),
                      blurRadius: 3,
                    ),
                  ],
                ),
              ),
              background:
                  actor!.profilePath.isNotEmpty
                      ? CachedNetworkImage(
                        imageUrl: MovieService.getImageUrl(actor!.profilePath),
                        fit: BoxFit.cover,
                      )
                      : Container(
                        color: Colors.grey[800],
                        child: Icon(
                          Icons.person,
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
                  // Actor Info
                  if (actor!.birthday.isNotEmpty)
                    Text(
                      'Born: ${actor!.birthday}',
                      style: TextStyle(fontSize: 16, color: Colors.grey[400]),
                    ),
                  if (actor!.placeOfBirth.isNotEmpty) ...[
                    SizedBox(height: 4),
                    Text(
                      'Place of Birth: ${actor!.placeOfBirth}',
                      style: TextStyle(fontSize: 16, color: Colors.grey[400]),
                    ),
                  ],
                  SizedBox(height: 16),

                  // Biography
                  if (actor!.biography.isNotEmpty) ...[
                    Text(
                      'Biography',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      actor!.biography,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Colors.grey[300],
                      ),
                    ),
                    SizedBox(height: 24),
                  ],

                  // Movies Section
                  Text(
                    'Movies (${actorMovies.length})',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // Movies Grid
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate((context, index) {
                final movie = actorMovies[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieDetailScreen(movie: movie),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey[900],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                            child:
                                movie.posterPath.isNotEmpty
                                    ? CachedNetworkImage(
                                      imageUrl: MovieService.getImageUrl(
                                        movie.posterPath,
                                      ),
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    )
                                    : Container(
                                      color: Colors.grey[800],
                                      child: Center(
                                        child: Icon(
                                          Icons.movie,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                movie.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4),
                              if (movie.releaseDate.isNotEmpty)
                                Text(
                                  movie.releaseDate.split('-')[0],
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 12,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }, childCount: actorMovies.length),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }
}
