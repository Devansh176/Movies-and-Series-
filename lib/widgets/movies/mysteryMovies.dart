import 'package:cineflix/description.dart';
import 'package:flutter/material.dart';

class MysteryMovies extends StatelessWidget {
  const MysteryMovies({super.key, required this.mysteryMovies});
  final List mysteryMovies;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final width = screenSize.width;
    final height = screenSize.height;
    final fontSize = width * 0.05;
    final padding = width * 0.05;

    return Container(
      padding: EdgeInsets.only(top: padding * 0.8, left: padding * 0.8,),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mystery Movies',
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize * 1.22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: height * 0.02,),
          SizedBox(
            height: height * 0.39,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: mysteryMovies.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Description(
                          name: mysteryMovies[index]['original_name'] ?? mysteryMovies[index]['title'],
                          bannerUrl: mysteryMovies[index]['backdrop_path'] != null?'https://image.tmdb.org/t/p/w500'+mysteryMovies[index]['backdrop_path'] : '',
                          posterUrl: mysteryMovies[index]['poster_path'] != null?'https://image.tmdb.org/t/p/w500'+mysteryMovies[index]['poster_path'] : '',
                          description: mysteryMovies[index]['overview'] ?? 'No description available',
                          vote: mysteryMovies[index]['vote_average']?.toString() ?? 'N/A',
                          launch_on: mysteryMovies[index]['release_date'] ?? 'Unknown',
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
                            image: DecorationImage(
                              image: NetworkImage(
                                  'https://image.tmdb.org/t/p/w500'+mysteryMovies[index]['poster_path']
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.025,),
                        Text(
                          mysteryMovies[index]['original_name'] != null? mysteryMovies[index]['original_name'] : mysteryMovies[index]['title'],
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