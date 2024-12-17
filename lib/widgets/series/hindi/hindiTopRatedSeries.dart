import 'package:cached_network_image/cached_network_image.dart';
import 'package:cineflix/description.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HindiTopRatedSeries extends StatefulWidget {
  const HindiTopRatedSeries({super.key, required this.hindiTopRatedSeries});
  final List hindiTopRatedSeries;

  @override
  State<HindiTopRatedSeries> createState() => _HindiTopRatedSeriesState();
}

class _HindiTopRatedSeriesState extends State<HindiTopRatedSeries> {
  late Box seriesTopRated;
  List cachedTopRated = [];
  bool isHiveInitialized = false;

  @override
  void initState() {
    super.initState();
    initializeHive();
    print("Widget Talk Show: ${widget.hindiTopRatedSeries.length}");
  }

  Future<void> initializeHive() async {
    try {
      print("Opening Hive Box...");
      seriesTopRated = await Hive.openBox('TopRatedBox');
      print("Hive Box Opened Successfully");
    } catch (e) {
      print("Error initializing Hive : $e");
    } finally {
      if (mounted) {
        setState(() {
          isHiveInitialized = true;
        });
        loadSeries();
      }
    }
  }

  void loadSeries() {
    final cachedData = seriesTopRated.get('hindiTopRatedSeries');
    if (cachedData != null && cachedData.isNotEmpty) {
      print("Cached data found in TopRated series : ${cachedData.length}");
      setState(() {
        cachedTopRated = List.from(cachedData);
      });
    } else {
      print("No cached data found. Using passed TopRated Series.");
      setState(() {
        cachedTopRated = widget.hindiTopRatedSeries;
      });
      seriesTopRated.put('hindiTopRatedSeries', widget.hindiTopRatedSeries);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isHiveInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    print("Rendering movies: ${cachedTopRated.length}");

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
            'Top Rated Series',
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
              itemCount: cachedTopRated.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Description(
                          name: cachedTopRated[index]['name'] != null? cachedTopRated[index]['original_name'] : cachedTopRated[index]['name'],
                          bannerUrl: cachedTopRated[index]['backdrop_path'] != null? 'https://image.tmdb.org/t/p/w500'+cachedTopRated[index]['backdrop_path'] : 'https://via.placeholder.com/150',
                          posterUrl: cachedTopRated[index]['poster_path'] != null? 'https://image.tmdb.org/t/p/w500'+cachedTopRated[index]['poster_path'] : 'https://via.placeholder.com/150',
                          description: cachedTopRated[index]['overview'] ?? 'No description available',
                          vote: cachedTopRated[index]['vote_average']?.toString() ?? 'N/A',
                          launch_on: cachedTopRated[index]['first_air_date'] ?? 'Unknown',
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
                            imageUrl: getValidImageUrl(cachedTopRated[index]['poster_path'],),
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => Icon(Icons.error, color: Colors.grey),
                          ),
                        ),
                        SizedBox(height: height * 0.025,),
                        Text(
                          cachedTopRated[index]['original_name'] != null? cachedTopRated[index]['original_name'] : 'Loading',
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
