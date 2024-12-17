import 'package:cached_network_image/cached_network_image.dart';
import 'package:cineflix/description.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HindiTrendingMovies extends StatefulWidget {
  const HindiTrendingMovies({super.key, required this.hindiTrending});
  final List hindiTrending;

  @override
  State<HindiTrendingMovies> createState() => _HindiTrendingMoviesState();
}

class _HindiTrendingMoviesState extends State<HindiTrendingMovies> {
  late Box trendingMoviesBox;
  List cachedTrendingMovies = [];
  bool isHiveInitialized = false;

  @override
  void initState() {
    super.initState();
    initializeHive();
    print("Widget trendingMovies: ${widget.hindiTrending.length}");
  }

  Future<void> initializeHive() async {
    try {
      print("Opening Hive Box...");
      trendingMoviesBox = await Hive.openBox('trendingMoviesBox');
      print("Hive Box Opened Successfully");
    } catch (e) {
      print("Error initializing Hive : $e");
    } finally {
      if (mounted) {
        setState(() {
          isHiveInitialized = true;
        });
        loadMovies();
      }
    }
  }

  void loadMovies() {
    final cachedData = trendingMoviesBox.get('trendingHindiMovies');
    if (cachedData != null && cachedData.isNotEmpty) {
      print("Cached data found: ${cachedData.length}");
      setState(() {
        cachedTrendingMovies = List.from(cachedData);
      });
    } else {
      print("No cached data found. Using passed trendingMovies.");
      setState(() {
        cachedTrendingMovies = widget.hindiTrending;
      });
      trendingMoviesBox.put('trendingHindiMovies', widget.hindiTrending);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isHiveInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    print("Rendering movies: ${cachedTrendingMovies.length}");
    final screenSize = MediaQuery.of(context).size;
    final width = screenSize.width;
    final height = screenSize.height;
    final fontSize = width * 0.05;
    final padding = width * 0.05;

    String getValidImageUrl(String? url) {
      return (url != null && url.isNotEmpty)
          ? 'https://image.tmdb.org/t/p/w500$url'
          : 'https://via.placeholder.com/300';
    }

    return Container(
      padding: EdgeInsets.only(top: padding * 0.8, left: padding * 0.8,),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trending Movies',
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize * 1.22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: height * 0.02,),
          SizedBox(
            height: height * 0.36,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: cachedTrendingMovies.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Description(
                          name: cachedTrendingMovies[index]['original_name'] != null? cachedTrendingMovies[index]['original_name'] : cachedTrendingMovies[index]['title'],
                          bannerUrl: cachedTrendingMovies[index]['backdrop_path'] != null?'https://image.tmdb.org/t/p/w500'+cachedTrendingMovies[index]['backdrop_path'] : '',
                          posterUrl: cachedTrendingMovies[index]['poster_path'] != null?'https://image.tmdb.org/t/p/w500'+cachedTrendingMovies[index]['poster_path'] : '',
                          description: cachedTrendingMovies[index]['overview'] ?? 'No description available',
                          vote: cachedTrendingMovies[index]['vote_average']?.toString() ?? 'N/A',
                          launch_on: cachedTrendingMovies[index]['first_air_date'] ?? cachedTrendingMovies[index]['release_date'],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: width * 0.4,
                    child: Column(
                      children: [
                        Container(
                          height: height * 0.25,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50,),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: getValidImageUrl(cachedTrendingMovies[index]['poster_path'],),
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => Icon(Icons.error, color: Colors.grey),
                          ),
                        ),
                        SizedBox(height: height * 0.025,),
                        Text(
                          cachedTrendingMovies[index]['original_name'] != null? cachedTrendingMovies[index]['original_name'] : cachedTrendingMovies[index]['title'],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: fontSize * 0.8,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
