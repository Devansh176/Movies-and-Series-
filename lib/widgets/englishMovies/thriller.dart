import 'package:cineflix/description.dart';
import 'package:flutter/material.dart';

class ThrillerMovies extends StatelessWidget {
  const ThrillerMovies({super.key, required this.thrillerMovies});
  final List thrillerMovies;

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
            'Thriller Movies',
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
              itemCount: thrillerMovies.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Description(
                          name: thrillerMovies[index]['original_name'] ?? thrillerMovies[index]['title'],
                          bannerUrl: thrillerMovies[index]['backdrop_path'] != null?'https://image.tmdb.org/t/p/w500'+thrillerMovies[index]['backdrop_path'] : '',
                          posterUrl: thrillerMovies[index]['poster_path'] != null?'https://image.tmdb.org/t/p/w500'+thrillerMovies[index]['poster_path'] : '',
                          description: thrillerMovies[index]['overview'] ?? 'No description available',
                          vote: thrillerMovies[index]['vote_average']?.toString() ?? 'N/A',
                          launch_on: thrillerMovies[index]['release_date'] ?? 'Unknown',
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
                                  'https://image.tmdb.org/t/p/w500'+thrillerMovies[index]['poster_path']
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.025,),
                        Text(
                          thrillerMovies[index]['original_name'] != null? thrillerMovies[index]['original_name'] : thrillerMovies[index]['title'],
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
