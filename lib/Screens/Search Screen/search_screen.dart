import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaushik_digital/Providers/search_provider.dart';
import 'package:kaushik_digital/Screens/Home/widgets/custom_bottom_sheet.dart';
import 'package:kaushik_digital/Screens/Home/widgets/custom_movie_container.dart';
import 'package:kaushik_digital/Screens/Login/widgets/custom_textfield.dart';
import 'package:kaushik_digital/Services/home_service.dart';
import 'package:kaushik_digital/utils/constants/constants.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  dynamic selectedLanguage;
  dynamic selectedGenre;
  HomeService homeService = HomeService();
  TextEditingController searchController = TextEditingController();
  bool _didFetch = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final searchProvider =
          Provider.of<SearchProvider>(context, listen: false);
      if (searchProvider.languages.isNotEmpty) {
        final hindiLang = searchProvider.languages.firstWhere(
          (lang) =>
              (lang['language_name']?.toString().toLowerCase() ?? '') ==
              'hindi',
          orElse: () => null,
        );
        if (hindiLang != null) {
          setState(() {
            selectedLanguage = hindiLang;
          });
          searchProvider.getShowsByLanguages(
            langId: hindiLang['language_id'],
            filter: "alpha",
            context: context,
          );
        }
      }
      // Set default genre to Drama
      if (searchProvider.genres.isNotEmpty) {
        final dramaGenre = searchProvider.genres.firstWhere(
          (genre) =>
              (genre['genre_name']?.toString().toLowerCase() ?? '') == 'drama',
          orElse: () => null,
        );
        if (dramaGenre != null) {
          setState(() {
            selectedGenre = dramaGenre;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    final searchProvider = Provider.of<SearchProvider>(context, listen: true);

    // Ensure languages and genres are fetched if not already
    if (!_didFetch &&
        (searchProvider.languages.isEmpty || searchProvider.genres.isEmpty) &&
        !searchProvider.isLoading) {
      _didFetch = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        searchProvider.fetchLanguages(context: context);
        searchProvider.fetchGenre(context: context);
      });
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent, // Make status bar transparent
        statusBarIconBrightness: Brightness.dark, // For white icons
      ),
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 35),
                CustomTextField(
                  labelText: "Search Movie",
                  controller: searchController,
                  textColor: Colors.black,
                  borderColor: Colors.black,
                  labelColor: Colors.black,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: h * 0.07,
                      width: w * 0.45,
                      child: DropdownButtonFormField<dynamic>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(color: primaryColor)),
                        ),
                        value: selectedLanguage,
                        items: searchProvider.languages.map((language) {
                          return DropdownMenuItem<dynamic>(
                            value: language,
                            child: Row(
                              children: [
                                Text(
                                  language['language_name'],
                                  style: TextStyle(
                                      fontSize: h * 0.015,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) async {
                          setState(() {
                            selectedLanguage = value;
                          });
                          searchProvider.getShowsByLanguages(
                              langId: value['language_id'],
                              filter: "alpha",
                              context: context);
                        },
                        hint: Text(
                          'Search by language',
                          style: TextStyle(
                              fontSize: h * 0.015,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: h * 0.07,
                      width: w * 0.4,
                      child: DropdownButtonFormField<dynamic>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(color: primaryColor)),
                        ),
                        value: selectedGenre,
                        items: searchProvider.genres.map((genre) {
                          return DropdownMenuItem<dynamic>(
                            value: genre,
                            child: Row(
                              children: [
                                Text(
                                  genre['genre_name'],
                                  style: TextStyle(
                                      fontSize: h * 0.015,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) async {
                          setState(() {
                            selectedGenre = value;
                          });
                          searchProvider.getShowsByLanguages(
                              langId: value['genre_id'],
                              filter: "alpha",
                              context: context);
                        },
                        hint: Text(
                          'Search by Genre',
                          style: TextStyle(
                              fontSize: h * 0.015,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: (searchProvider.isLoading ||
                          searchProvider.languages.isEmpty ||
                          searchProvider.genres.isEmpty)
                      ? const Center(child: CircularProgressIndicator())
                      : searchProvider.showsByLanguages.isNotEmpty
                          ? SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0, vertical: 5),
                                    child: Text(
                                      "Latest Movies",
                                      style: GoogleFonts.roboto(
                                        textStyle: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  ..._shouldDuplicate()
                                      ? List.generate(
                                          4,
                                          (i) => _buildMovieList(
                                              h, w, searchProvider))
                                      : [_buildMovieList(h, w, searchProvider)],
                                ],
                              ),
                            )
                          : const Center(
                              child: Text(
                                "Search Your Favorite Movie",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _shouldDuplicate() {
    if (selectedLanguage == null || selectedGenre == null) return false;
    final langName =
        (selectedLanguage['language_name'] ?? '').toString().toLowerCase();
    final genreName =
        (selectedGenre['genre_name'] ?? '').toString().toLowerCase();
    return langName == 'hindi' && genreName == 'drama';
  }

  Widget _buildMovieList(double h, double w, SearchProvider searchProvider) {
    return SizedBox(
      height: h * 0.3,
      child: searchProvider.showsByLanguages["VIDEO_STREAMING_APP"].isEmpty
          ? const Center(
              child: Text(
                "No movies available.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            )
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount:
                  searchProvider.showsByLanguages["VIDEO_STREAMING_APP"].length,
              padding: const EdgeInsets.only(left: 10),
              itemBuilder: (context, rowIndex) {
                var moviesList =
                    searchProvider.showsByLanguages["VIDEO_STREAMING_APP"];
                var latestmovies = moviesList[rowIndex % moviesList.length];
                return CustomMoviesContainer(
                  h: h * 0.7,
                  moviePoster: latestmovies['show_poster'],
                  w: w * 0.65,
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(16.0)),
                      ),
                      builder: (BuildContext context) {
                        return MovieBottomSheet(
                          context: context,
                          movieName: latestmovies['show_title'],
                          duration: latestmovies['show_duration'] ?? '',
                          moviePoster: latestmovies['show_poster'],
                          moviePrice: latestmovies['price'] ?? 0,
                        );
                      },
                    );
                  },
                  movieName: latestmovies['show_title'],
                  moviePrice: latestmovies['price'] ?? 0,
                );
              },
            ),
    );
  }
}



// void main() {
//   runApp(const MaterialApp(
//     home: SearchScreen(),
//   ));
// }













// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:kaushik_digital/Screens/Login/widgets/custom_textfield.dart';

// class SearchScreen extends StatelessWidget {
//   const SearchScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     List tvList = [
//       "assets/images/tv_poster1.jpg",
//       "assets/images/tv_poster2.jpg",
//       "assets/images/tv_poster3.jpg",
//       "assets/images/tv_poster1.jpg",
//     ];
//     double h = MediaQuery.of(context).size.height;
//     double w = MediaQuery.of(context).size.width;
//     TextEditingController searchController = TextEditingController();
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         elevation: 3,
//         backgroundColor: Colors.white,
//         toolbarHeight: 30,
//         automaticallyImplyLeading: false,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.only(right: 12.0, left: 12, bottom: 8),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             CustomTextField(
//               labelText: "Search Movie",
//               controller: searchController,
//               textColor: Colors.black,
//               borderColor: Colors.black,
//               labelColor: Colors.black,
//             ),
//             SizedBox(
//               height: h * 0.01,
//             ),
//             Expanded(
//               child: ListView.builder(
//                 itemBuilder: (context, index) {
//                   return Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(20),
//                         color: const Color.fromARGB(255, 224, 225, 226)),
//                     margin: const EdgeInsets.only(bottom: 10),
//                     child: Row(
//                       // crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Container(
//                           width: w * 0.4, // Width of each container
//                           height: h * 0.15,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(20),
//                             image: DecorationImage(
//                                 image: AssetImage(tvList[index]),
//                                 fit: BoxFit.fill),
//                           ), // Height of each container
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(10.0),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               SizedBox(
//                                 width: w * 0.32,
//                                 child: Text(
//                                   "Movie Name",
//                                   overflow: TextOverflow.ellipsis,
//                                   style: GoogleFonts.roboto(
//                                     textStyle: const TextStyle(
//                                         fontSize: 15,
//                                         fontWeight: FontWeight.w700,
//                                         color: Colors.black),
//                                   ),
//                                 ),
//                               ),
//                               const Text(
//                                 "Genre : Action",
//                                 style: TextStyle(
//                                     fontSize: 12, fontWeight: FontWeight.w500),
//                               ),
//                               const Text(
//                                 "HollyWood",
//                                 style: TextStyle(
//                                     fontSize: 12, fontWeight: FontWeight.w500),
//                               ),
//                               const Text(
//                                 "IMDB | 8.9",
//                                 style: TextStyle(
//                                     fontSize: 12, fontWeight: FontWeight.w500),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const Spacer(),
//                         const Icon(
//                           Icons.play_arrow_rounded,
//                           size: 35,
//                         )
//                       ],
//                     ),
//                   );
//                 },
//                 itemCount: tvList.length,
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
