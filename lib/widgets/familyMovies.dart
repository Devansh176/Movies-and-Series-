import 'package:cineflix/description.dart';
import 'package:flutter/material.dart';

class FamilyMovies extends StatelessWidget {
  const FamilyMovies({super.key, required this.familyMovies});
  final List familyMovies;

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
            'Family Movies',
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
              itemCount: familyMovies.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Description(
                          name: familyMovies[index]['original_name'] ?? familyMovies[index]['title'],
                          bannerUrl: familyMovies[index]['backdrop_path'] != null?'https://image.tmdb.org/t/p/w500'+familyMovies[index]['backdrop_path'] : '',
                          posterUrl: familyMovies[index]['poster_path'] != null?'https://image.tmdb.org/t/p/w500'+familyMovies[index]['poster_path'] : '',
                          description: familyMovies[index]['overview'] ?? 'No description available',
                          vote: familyMovies[index]['vote_average']?.toString() ?? 'N/A',
                          launch_on: familyMovies[index]['release_date'] ?? 'Unknown',
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
                                  'https://image.tmdb.org/t/p/w500'+familyMovies[index]['poster_path']
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.025,),
                        Text(
                          familyMovies[index]['original_name'] != null? familyMovies[index]['original_name'] : familyMovies[index]['title'],
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
