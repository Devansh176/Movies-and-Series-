import 'package:cineflix/description.dart';
import 'package:flutter/material.dart';

class RomanceMovies extends StatelessWidget {
  const RomanceMovies({super.key, required this.romanceMovies});
  final List romanceMovies;

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
            'Romance Movies',
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
              itemCount: romanceMovies.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Description(
                          name: romanceMovies[index]['original_name'] ?? romanceMovies[index]['title'],
                          bannerUrl: romanceMovies[index]['backdrop_path'] != null?'https://image.tmdb.org/t/p/w500'+romanceMovies[index]['backdrop_path'] : '',
                          posterUrl: romanceMovies[index]['poster_path'] != null?'https://image.tmdb.org/t/p/w500'+romanceMovies[index]['poster_path'] : '',
                          description: romanceMovies[index]['overview'] ?? 'No description available',
                          vote: romanceMovies[index]['vote_average']?.toString() ?? 'N/A',
                          launch_on: romanceMovies[index]['release_date'] ?? 'Unknown',
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
                                  'https://image.tmdb.org/t/p/w500'+romanceMovies[index]['poster_path']
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.025,),
                        Text(
                          romanceMovies[index]['original_name'] != null? romanceMovies[index]['original_name'] : romanceMovies[index]['title'],
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
