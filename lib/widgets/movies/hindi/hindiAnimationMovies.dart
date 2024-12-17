import 'package:cached_network_image/cached_network_image.dart';
import 'package:cineflix/description.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HindiAnimationMovies extends StatefulWidget {
  const HindiAnimationMovies({super.key, required this.hindiAnimationMovies});
  final List hindiAnimationMovies;

  @override
  State<HindiAnimationMovies> createState() => _HindiAnimationMoviesState();
}

class _HindiAnimationMoviesState extends State<HindiAnimationMovies> {
  late Box animationBox;
  List cachedAnimationMovies = [];
  bool isHiveInitialized = false;

  @override
  void initState() {
    super.initState();
    initializeHive();
    print("Widget animationMovies: ${widget.hindiAnimationMovies.length}");
  }

  Future<void> initializeHive() async {
    try {
      print("Opening Hive Box...");
      animationBox = await Hive.openBox('AnimationMoviesBox');
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
    final cachedData = animationBox.get('animationHindiMovies');
    if (cachedData != null && cachedData.isNotEmpty) {
      print("Cached data found in animation : ${cachedData.length}");
      setState(() {
        cachedAnimationMovies = List.from(cachedData);
      });
    } else {
      print("No cached data found. Using passed animationMovies.");
      setState(() {
        cachedAnimationMovies = widget.hindiAnimationMovies;
      });
      animationBox.put('animationHindiMovies', widget.hindiAnimationMovies);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isHiveInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    print("Rendering movies: ${cachedAnimationMovies.length}");

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
            'Animation Movies',
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
              itemCount: cachedAnimationMovies.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Description(
                          name: cachedAnimationMovies[index]['original_name'] ?? cachedAnimationMovies[index]['title'],
                          bannerUrl: cachedAnimationMovies[index]['backdrop_path'] != null?'https://image.tmdb.org/t/p/w500'+cachedAnimationMovies[index]['backdrop_path'] : '',
                          posterUrl: cachedAnimationMovies[index]['poster_path'] != null?'https://image.tmdb.org/t/p/w500'+cachedAnimationMovies[index]['poster_path'] : '',
                          description: cachedAnimationMovies[index]['overview'] ?? 'No description available',
                          vote: cachedAnimationMovies[index]['vote_average']?.toString() ?? 'N/A',
                          launch_on: cachedAnimationMovies[index]['release_date'] ?? 'Unknown',
                        ),
                      ),
                    );
                  },
                  child: SizedBox(
                    width: width * 0.4,
                    child: Column(
                      children: [
                        Container(
                          height: height * 0.25,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50,),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: getValidImageUrl(cachedAnimationMovies[index]['poster_path'],),
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => Icon(Icons.error, color: Colors.grey),
                          ),
                        ),
                        SizedBox(height: height * 0.025,),
                        Text(
                          cachedAnimationMovies[index]['original_name'] != null? cachedAnimationMovies[index]['original_name'] : cachedAnimationMovies[index]['title'],
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